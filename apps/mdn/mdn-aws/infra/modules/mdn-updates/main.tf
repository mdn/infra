locals {
  aliases     = var.environment == "prod" ? ["updates.developer.mozilla.org", "updates.prod.mdn.mozit.cloud"] : ["updates.developer.allizom.org", "updates.stage.mdn.mozit.cloud"]
  bucket_name = "updates-${var.environment}-developer-${var.environment == "prod" ? "mozilla" : "allizom"}"
}

resource "random_id" "rand_var" {
  keepers = {
    bucket_name = local.bucket_name
  }

  byte_length = 8
}

# IAM user with programmatic access keys that we can use for our GitHub Action secrets
resource "aws_iam_user" "updates_user" {
  name = "${local.bucket_name}-${random_id.rand_var.hex}-user"
  path = "/itsre/"

  tags = {
    Name        = "${local.bucket_name}-${random_id.rand_var.hex}-user"
    Environment = var.environment
    Service     = "MDN"
    Purpose     = "Cloudfront Updates bucket user"
  }
}

# Allow the user full access to the S3 bucket
resource "aws_iam_user_policy" "updates_user" {
  name   = "${aws_iam_user.updates_user.name}-iam-policy"
  user   = aws_iam_user.updates_user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::${local.bucket_name}-${random_id.rand_var.hex}",
            "arn:aws:s3:::${local.bucket_name}-${random_id.rand_var.hex}/*"
        ]
    }]
}
EOF
}

data "aws_iam_policy_document" "public_read" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.bucket_name}-${random_id.rand_var.hex}/*"
    ]
  }
}


# S3 buckets to be used as origins for the Cloudfront instances
resource "aws_s3_bucket" "updates_bucket" {
  bucket = "${local.bucket_name}-${random_id.rand_var.hex}"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  policy = data.aws_iam_policy_document.public_read.json

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    # Lifecycle rule that expires all objects after 3 months
    expiration {
      days = var.expiration_days
    }
  }

  tags = {
    Name        = "${local.bucket_name}-${random_id.rand_var.hex}"
    Environment = var.environment
    Service     = "MDN"
    Purpose     = "Cloudfront Update bucket"
  }
}

# These were created via ClickOps
data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "MDN-Origin-And-All-Query-Strings"
}

data "aws_cloudfront_cache_policy" "cache_policy_one_year" {
  name = "MDN-Yearlong-Caching"
}

data "aws_cloudfront_origin_request_policy" "origin_policy" {
  name = "Managed-CORS-S3Origin"
}

# Create Cloudfront distribution
resource "aws_cloudfront_distribution" "updates_distribution" {
  comment = "MDN ${var.environment} Updates CDN"
  aliases = local.aliases
  enabled = true

  origin {
    domain_name = aws_s3_bucket.updates_bucket.website_endpoint
    origin_id   = aws_s3_bucket.updates_bucket.id

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  # default – with CachingDisabled caching policy and CORS-S3Origin origin request policy
  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = aws_s3_bucket.updates_bucket.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.cache_policy.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.origin_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    # No cache
    default_ttl = 0
    max_ttl     = 0
    min_ttl     = 0
  }

  # /packages – with MDN-Yearlong-Caching caching policy and CORS-S3Origin origin request policy
  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern             = "/packages/*"
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = data.aws_cloudfront_cache_policy.cache_policy_one_year.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.origin_policy.id
    target_origin_id         = aws_s3_bucket.updates_bucket.id

    # Yearlong cache policy
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Service   = "MDN"
    Purpose   = "MDN ${var.environment} Updates CDN"
    Terraform = "true"
  }
}

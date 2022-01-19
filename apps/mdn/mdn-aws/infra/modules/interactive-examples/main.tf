locals {
  aliases_map = {
    "prod"  = ["interactive-examples.prod.mdn.mozilla.net"]
    "stage" = ["interactive-examples.stage.mdn.mozilla.net"]
  }

  bucket_name = "interactive-examples-${var.environment}"
}

resource "random_id" "rand_var" {
  keepers = {
    bucket_name = local.bucket_name
  }

  byte_length = 8
}

# IAM user with programmatic access keys that we can use for our GitHub Action secrets
resource "aws_iam_user" "interactive_examples_user" {
  name = "${local.bucket_name}-${random_id.rand_var.hex}-user"
  path = "/itsre/"

  tags = {
    Name        = "${local.bucket_name}-${random_id.rand_var.hex}-user"
    Environment = var.environment
    Service     = "MDN"
    Purpose     = "Cloudfront interactive examples bucket user"
  }
}

# Allow the user full access to the S3 bucket
resource "aws_iam_user_policy" "interactive_examples_user" {
  name   = "${aws_iam_user.interactive_examples_user.name}-iam-policy"
  user   = aws_iam_user.interactive_examples_user.name
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
resource "aws_s3_bucket" "interactive_examples_bucket" {
  bucket = "${local.bucket_name}-${random_id.rand_var.hex}"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
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

  tags = {
    Name        = "${local.bucket_name}-${random_id.rand_var.hex}"
    Environment = var.environment
    Service     = "MDN"
    Purpose     = "Cloudfront Update bucket"
  }
}

# Create Cloudfront distribution
resource "aws_cloudfront_distribution" "interactive_examples_distribution" {
  comment = "MDN ${var.environment} Interactive Examples CDN"
  aliases = lookup(local.aliases_map, var.environment)
  enabled = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.interactive_examples_bucket.website_endpoint
    origin_id   = aws_s3_bucket.interactive_examples_bucket.id

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.interactive_examples_bucket.id
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 86400
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
    Purpose   = "MDN ${var.environment} Interactive Examples CDN"
    Terraform = "true"
  }
}

data "aws_caller_identity" "current" {
}

locals {
  site-bucket      = "${var.bucket_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"
  site-bucket-logs = "${var.bucket_name}-${var.environment}-${data.aws_caller_identity.current.account_id}-logs"
  servicename      = "${var.servicename}-${var.environment}"
}

resource "aws_s3_bucket" "site-bucket-logs" {
  bucket = local.site-bucket-logs
  acl    = "log-delivery-write"

  tags = {
    Name      = local.site-bucket-logs
    Service   = local.servicename
    Region    = var.region
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.site-bucket}",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid    = "AllowIndexDotHTML"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.site-bucket}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "site-bucket" {
  bucket = local.site-bucket
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  logging {
    target_bucket = aws_s3_bucket.site-bucket-logs.id
    target_prefix = "logs/"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = var.s3_versioning
  }

  policy = data.aws_iam_policy_document.bucket_policy.json

  tags = {
    Name        = local.site-bucket
    ServiceName = local.servicename
    Region      = var.region
    Terraform   = "true"
  }
}

resource "aws_cloudfront_distribution" "site-distribution" {
  enabled             = var.cloudfront_enabled
  comment             = "Cloudfront distribution for ${local.site-bucket}"
  default_root_object = "index.html"
  aliases             = var.cloudfront_aliases
  is_ipv6_enabled     = var.enable_ipv6

  logging_config {
    bucket = aws_s3_bucket.site-bucket-logs.bucket_domain_name
    prefix = "${var.environment}-cdn-logs/"
  }

  origin {
    domain_name = aws_s3_bucket.site-bucket.website_endpoint
    origin_id   = "origin-${local.site-bucket}"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-${local.site-bucket}"

    lambda_function_association {
      event_type = "viewer-response"
      lambda_arn = aws_lambda_function.lambda-headers.qualified_arn
    }

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.cloudfront_protocol_policy
    compress               = true
    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

data "aws_iam_policy_document" "lambda-exec-role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
  }
}

# Lambda@edge to set origin response headers
resource "aws_iam_role" "lambda-edge-role" {
  name               = "${local.servicename}-lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-exec-role.json
}

data "archive_file" "lambda-zip" {
  type        = "zip"
  source_file = "${path.module}/lambda-headers.js"
  output_path = "${path.module}/lambda-headers.zip"
}

# We do this because lambda@edge needs to be in us-east-1
provider "aws" {
  alias  = "aws-lambda-east"
  region = "us-east-1"
}

resource "aws_lambda_function" "lambda-headers" {
  provider         = aws.aws-lambda-east
  function_name    = "${local.servicename}-headers"
  description      = "Provides Correct Response Headers for ${local.servicename}"
  publish          = "true"
  filename         = "${path.module}/lambda-headers.zip"
  source_code_hash = data.archive_file.lambda-zip.output_base64sha256
  role             = aws_iam_role.lambda-edge-role.arn
  handler          = var.event_trigger
  runtime          = "nodejs12.x"

  tags = {
    Name        = "${local.servicename}-headers"
    ServiceName = local.servicename
    Terraform   = "true"
  }
}


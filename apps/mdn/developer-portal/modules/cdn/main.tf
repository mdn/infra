data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "selected" {
  bucket = "${var.origin_bucket}"
}

data "aws_s3_bucket" "logging" {
  bucket = "${var.logging_bucket}"
}

locals {
  servicename = "${var.servicename}-${var.environment}"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = "${var.enabled}"
  comment             = "developer-portal ${var.environment} CDN"
  default_root_object = "index.html"
  aliases             = "${var.cdn_aliases}"

  #logging_config {
  #  include_cookies = false
  #  bucket          = "${data.aws_s3_bucket.logging.bucket_domain_name}"
  #  prefix          = "cdn/"
  #}

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "300"
    response_code         = "404"
    response_page_path    = "/404.html"
  }
  origin {
    domain_name = "${data.aws_s3_bucket.selected.website_endpoint}"
    origin_id   = "origin-${var.origin_bucket}"

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
    target_origin_id = "origin-${var.origin_bucket}"
    compress         = "${var.cdn_compress}"

    lambda_function_association {
      event_type = "viewer-response"
      lambda_arn = "${aws_lambda_function.lambda-headers.qualified_arn}"
    }

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${var.cloudfront_protocol_policy}"
    min_ttl                = 0
    default_ttl            = 600
    max_ttl                = 600
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "${var.certificate_arn}"
    minimum_protocol_version = "${var.minimum_protocol_version}"
    ssl_support_method       = "sni-only"
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
  assume_role_policy = "${data.aws_iam_policy_document.lambda-exec-role.json}"
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
  provider         = "aws.aws-lambda-east"
  function_name    = "${local.servicename}-headers"
  description      = "Provides Correct Response Headers for ${local.servicename}"
  publish          = "true"
  filename         = "${path.module}/lambda-headers.zip"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  role             = "${aws_iam_role.lambda-edge-role.arn}"
  handler          = "${var.event_trigger}"
  runtime          = "nodejs10.x"

  tags {
    Name        = "${local.servicename}-headers"
    ServiceName = "${local.servicename}"
    Terraform   = "true"
  }
}

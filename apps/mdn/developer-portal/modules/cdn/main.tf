data "aws_caller_identity" "current" {
}

data "aws_s3_bucket" "logging" {
  count  = var.enable_logging ? 1 : 0
  bucket = var.logging_bucket
}

locals {
  servicename        = "${var.servicename}-${var.environment}"
  origin_domain_name = var.origin_domain_name == "" ? "developer-portal-origin.${var.environment}.mdn.mozit.cloud" : var.origin_domain_name
  origin_id          = var.origin_id == "" ? "developer-portal-${var.environment}-origin" : var.origin_id
}

resource "aws_cloudfront_distribution" "this" {
  enabled    = var.enabled
  comment    = "developer-portal ${var.environment} CDN"
  aliases    = var.cdn_aliases
  web_acl_id = var.web_acl_id

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
    domain_name = local.origin_domain_name
    origin_id   = local.origin_id

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  ordered_cache_behavior {
    path_pattern           = "static/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = ["Host"]
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = var.cdn_compress
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.cloudfront_protocol_policy
    min_ttl                = 0
    default_ttl            = 84600
    max_ttl                = 84600
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = "sni-only"
  }
  tags = {
    Name        = "developer-portal ${var.environment} CDN"
    Environment = var.environment
    Terraform   = "true"
  }
}

provider "aws" {
  alias  = "aws-lambda-east"
  region = "us-east-1"
}

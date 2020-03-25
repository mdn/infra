locals {
  log_bucket = "${var.distribution_name}-logs"
}

resource "random_id" "rand-var" {
  keepers = {
    bucket_name = local.log_bucket
  }

  byte_length = 8
}

resource "aws_s3_bucket" "logging" {
  count  = var.enabled
  bucket = "${local.log_bucket}-${random_id.rand-var.hex}"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = var.standard_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }
  }

  tags = {
    Name        = "${local.log_bucket}-${random_id.rand-var.hex}"
    Environment = var.environment
    Service     = "MDN"
    Purpose     = "Cloudfront logging bucket"
  }
}

resource "aws_cloudfront_distribution" "mdn-attachments-cf-dist" {
  count           = var.enabled
  aliases         = var.aliases
  comment         = var.comment
  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = false
  price_class     = "PriceClass_All"

  logging_config {
    include_cookies = var.cloudfront_log_cookies
    bucket          = aws_s3_bucket.logging[0].bucket_domain_name
    prefix          = var.cloudfront_log_prefix
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
  }

  # 0
  ordered_cache_behavior {
    path_pattern = "static/*"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = var.distribution_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true

    default_ttl = 86400
    max_ttl     = 432000
    min_ttl     = 0

    smooth_streaming       = false
    target_origin_id       = var.distribution_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string            = true
      query_string_cache_keys = ["revision"]

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = var.domain_name
    origin_id   = var.distribution_name

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method  = "sni-only"

    # https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#minimum_protocol_version
    minimum_protocol_version = "TLSv1"
  }

  tags = {
    Name        = var.distribution_name
    Environment = var.environment
    Purpose     = "Attachment CDN"
    Service     = "MDN"
  }
}


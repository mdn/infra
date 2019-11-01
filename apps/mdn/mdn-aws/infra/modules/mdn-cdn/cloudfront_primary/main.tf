locals {
  log_bucket = "${var.distribution_name}-logs"
}

data "aws_s3_bucket" "api_bucket" {
  bucket = "${var.api_bucket}"
}

resource "random_id" "rand-var" {
  keepers = {
    bucket_name = "${local.log_bucket}"
  }

  byte_length = 8
}

resource "aws_s3_bucket" "logging" {
  count  = "${var.enabled}"
  bucket = "${local.log_bucket}-${random_id.rand-var.hex}"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = "${var.standard_transition_days}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "${var.glacier_transition_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.expiration_days}"
    }
  }

  tags {
    Name        = "${local.log_bucket}-${random_id.rand-var.hex}"
    Environment = "${var.environment}"
    Service     = "MDN"
    Purpose     = "Cloudfront logging bucket"
  }
}

resource "aws_cloudfront_distribution" "mdn-primary-cf-dist" {
  count = "${var.enabled}"

  aliases         = "${var.aliases}"
  comment         = "${var.comment}"
  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"

  logging_config {
    include_cookies = "${var.cloudfront_log_cookies}"
    bucket          = "${aws_s3_bucket.logging.bucket_domain_name}"
    prefix          = "${var.cloudfront_log_prefix}"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 400
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 500
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 502
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 504
  }

  # 0
  ordered_cache_behavior {
    path_pattern = "static/js/libs/ckeditor/build/*"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers                 = ["Host"]
      query_string            = true
      query_string_cache_keys = ["t"]

      cookies {
        forward = "none"
      }
    }
  }

  # 1
  ordered_cache_behavior {
    path_pattern = "static/*"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = ["Host"]
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # 2
  ordered_cache_behavior {
    path_pattern = "media/*"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = ["Host"]
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # 3
  ordered_cache_behavior {
    path_pattern = "*/docs/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Accept-Language"]

      cookies {
        forward           = "whitelist"
        whitelisted_names = ["django_language"]
      }
    }
  }

  # 4
  ordered_cache_behavior {
    path_pattern = "users/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  # 5
  ordered_cache_behavior {
    path_pattern = "*/users/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  # 6
  ordered_cache_behavior {
    path_pattern = "*/profile/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  # 7
  ordered_cache_behavior {
    path_pattern = "*/profiles/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  # 8
  ordered_cache_behavior {
    path_pattern = "admin/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  # 9
  ordered_cache_behavior {
    path_pattern = "api/v1/doc/*"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 3600
    max_ttl                = 3600
    min_ttl                = 3600
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # 10
  ordered_cache_behavior {
    path_pattern = "api/*"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "${var.distribution_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Accept-Language"]

      cookies {
        forward           = "whitelist"
        whitelisted_names = ["django_language"]
      }
    }
  }

  origin {
    domain_name = "${data.aws_s3_bucket.api_bucket.website_endpoint}"
    origin_id   = "S3-${var.api_bucket}"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  origin {
    domain_name = "${var.domain_name}"
    origin_id   = "${var.distribution_name}"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = "${var.origin_read_timeout}"
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
    acm_certificate_arn = "${var.acm_cert_arn}"
    ssl_support_method  = "sni-only"

    # https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#minimum_protocol_version
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags {
    Name        = "${var.distribution_name}"
    Environment = "${var.environment}"
    Purpose     = "Primary CDN"
    Service     = "MDN"
  }
}

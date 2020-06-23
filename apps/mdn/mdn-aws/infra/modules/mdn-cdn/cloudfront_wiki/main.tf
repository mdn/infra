locals {
  distribution_name = "${var.distribution_name}-${var.environment}"
  media_origin_id   = "S3-${var.media_bucket}"
}

data "aws_s3_bucket" "media_bucket" {
  bucket = var.media_bucket
}

resource "aws_cloudfront_distribution" "mdn-wiki" {
  count           = var.enabled
  aliases         = var.aliases
  is_ipv6_enabled = var.enable_ipv6
  comment         = "MDN wiki ${var.environment} CDN"
  enabled         = true

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
    target_origin_id       = local.distribution_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string            = true
      headers                 = ["Host"]
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
    target_origin_id       = local.distribution_name
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
    target_origin_id       = local.distribution_name
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
    path_pattern = "sitemap.xml"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 43200
    max_ttl                = 43200
    min_ttl                = 43200
    smooth_streaming       = false
    target_origin_id       = local.media_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # 4
  ordered_cache_behavior {
    path_pattern = "sitemaps/*"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 43200
    max_ttl                = 43200
    min_ttl                = 43200
    smooth_streaming       = false
    target_origin_id       = local.media_origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
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
    target_origin_id       = local.distribution_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  origin {
    domain_name = data.aws_s3_bucket.media_bucket.bucket_domain_name
    origin_id   = local.media_origin_id
  }

  origin {
    domain_name = var.origin_domain
    origin_id   = local.distribution_name

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = var.origin_read_timeout
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
    acm_certificate_arn      = var.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags = {
    Name        = local.distribution_name
    Environment = var.environment
    Purpose     = "Wiki CDN"
    Service     = "MDN"
  }
}


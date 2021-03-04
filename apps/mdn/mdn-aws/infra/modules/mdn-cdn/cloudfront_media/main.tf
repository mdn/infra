data "aws_s3_bucket" "this" {
  bucket = var.media_bucket
}

data "aws_caller_identity" "current" {
}

# NOTE: MDN-Origin-And-All-Query-Strings and Managed-CORS-S3Origin should be
#       actually created resources. Instead we are doing this because it was created
#       by hand and I wanted a quick way of pulling their ID. The real fix should be
#       to import these 2 policies and have them reflected in code
data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "MDN-Origin-And-All-Query-Strings"
}

data "aws_cloudfront_origin_request_policy" "origin_policy" {
  name = "Managed-CORS-S3Origin"
}

locals {
  origin_id                = "S3-${var.media_bucket}"
  origin_request_policy_id = var.origin_request_policy_id == "" ? data.aws_cloudfront_origin_request_policy.origin_policy.id : var.origin_request_policy_id
  cache_policy_id          = var.cache_policy_id == "" ? data.aws_cloudfront_cache_policy.cache_policy.id : var.cache_policy_id
}

resource "aws_cloudfront_distribution" "this" {
  count   = var.enabled
  aliases = var.aliases
  comment = "MDN ${var.environment} Media CDN"
  enabled = true

  origin {
    domain_name = data.aws_s3_bucket.this.website_endpoint
    origin_id   = local.origin_id

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.origin_id
    origin_request_policy_id = local.origin_request_policy_id
    cache_policy_id          = local.cache_policy_id
    viewer_protocol_policy   = "redirect-to-https"
    default_ttl              = var.default_cache_default_ttl
    max_ttl                  = var.default_cache_max_ttl
    min_ttl                  = var.default_cache_min_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Service   = "MDN"
    Purpose   = "MDN ${var.environment} Media CDN"
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "cdn-policy" {
  count = var.enabled
  statement {
    sid    = "AllowInvalidateCache"
    effect = "Allow"

    actions = [
      "cloudfront:ListInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:CreateInvalidation",
    ]

    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.this[0].id}",
    ]
  }
}

resource "aws_iam_policy" "cdn-invalidate" {
  count  = var.enabled
  name   = "${var.media_bucket}-${var.environment}-cdn-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.cdn-policy[0].json
}


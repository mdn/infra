data "aws_s3_bucket" "this" {
  bucket = "${var.media_bucket}"
}

data "aws_caller_identity" "current" {}

locals {
  origin_id = "S3-${var.media_bucket}"
}

resource "aws_cloudfront_distribution" "this" {
  aliases = "${var.aliases}"
  comment = "MDN ${var.environment} Media CDN"
  enabled = true

  origin {
    domain_name = "${data.aws_s3_bucket.this.website_endpoint}"
    origin_id   = "${local.origin_id}"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 5
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.origin_id}"
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 86400
    max_ttl                = 432000
    min_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.certificate_arn}"
    ssl_support_method  = "sni-only"
  }

  tags {
    Service   = "MDN"
    Purpose   = "MDN ${var.environment} Media CDN"
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "cdn-policy" {
  statement {
    sid    = "AllowInvalidateCache"
    effect = "Allow"

    actions = [
      "cloudfront:ListInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:CreateInvalidation",
    ]

    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.this.id}",
    ]
  }
}

resource "aws_iam_policy" "cdn-invalidate" {
  name   = "${var.media_bucket}-${var.environment}-cdn-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.cdn-policy.json}"
}

# FIXME: This exists still because of logs, yari still sends logs to this bucket
# please fixme
module "primary-cloudfront" {
  source            = "./cloudfront_primary"
  environment       = var.environment
  distribution_name = "${var.cloudfront_primary_distribution_name}-${var.environment}"
}

########################################
# Attachments origin
########################################

module "cloudfront-attachments" {
  source            = "./cloudfront_attachments"
  enabled           = var.enabled && var.cloudfront_attachments_enabled ? 1 : 0
  environment       = var.environment
  distribution_name = "${var.cloudfront_attachments_distribution_name}-${var.environment}"
  comment           = "MDN ${var.environment} Attachments CDN"
  acm_cert_arn      = var.acm_attachments_cert_arn
  aliases           = var.cloudfront_attachments_aliases
  domain_name       = var.cloudfront_attachments_domain_name
}

module "media-cdn" {
  source          = "./cloudfront_media"
  enabled         = var.enabled && var.cloudfront_media_enabled ? 1 : 0
  environment     = var.environment
  aliases         = var.cloudfront_media_aliases
  certificate_arn = var.acm_media_cert_arn
  media_bucket    = var.cloudfront_media_bucket
}


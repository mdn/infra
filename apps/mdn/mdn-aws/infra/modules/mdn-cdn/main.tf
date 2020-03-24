provider "aws" {
  region = var.region
}

########################################
# Primary CDN
########################################

module "primary-cloudfront" {
  source              = "./cloudfront_primary"
  enabled             = var.enabled && var.cloudfront_primary_enabled ? 1 : 0
  distribution_name   = "${var.cloudfront_primary_distribution_name}-${var.environment}"
  environment         = var.environment
  comment             = "MDN Primary ${var.environment} CDN"
  acm_cert_arn        = var.acm_primary_cert_arn
  aliases             = var.cloudfront_primary_aliases
  domain_name         = var.cloudfront_primary_domain_name
  origin_read_timeout = "120"
  api_bucket          = var.cloudfront_primary_api_bucket
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

# Wiki CDN
module "wiki-cdn" {
  source            = "./cloudfront_wiki"
  enabled           = var.enabled && var.cloudfront_wiki_enabled ? 1 : 0
  environment       = var.environment
  distribution_name = var.cloudfront_wiki_distribution_name
  acm_cert_arn      = var.acm_wiki_cert_arn
  aliases           = var.cloudfront_wiki_aliases
  origin_domain     = var.cloudfront_wiki_origin_domain
}

module "media-cdn" {
  source          = "./cloudfront_media"
  enabled         = var.enabled && var.cloudfront_media_enabled ? 1 : 0
  environment     = var.environment
  aliases         = var.cloudfront_media_aliases
  certificate_arn = var.acm_media_cert_arn
  media_bucket    = var.cloudfront_media_bucket
}


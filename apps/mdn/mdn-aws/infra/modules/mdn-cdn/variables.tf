variable "region" {
  default = "us-west-2"
}

variable "enabled" {
}

variable "environment" {
}

variable "cloudfront_primary_distribution_name" {
  default = "mdn-primary-cdn"
}

variable "cloudfront_attachments_enabled" {
}

variable "cloudfront_attachments_aliases" {
  type = list(string)
}

variable "cloudfront_attachments_distribution_name" {
  default = "mdn-attachments-cdn"
}

variable "cloudfront_attachments_domain_name" {
}

variable "acm_attachments_cert_arn" {
}

variable "cloudfront_media_enabled" {
}

variable "cloudfront_media_aliases" {
  type = list(string)
}

variable "acm_media_cert_arn" {
}

variable "cloudfront_media_bucket" {
}

variable "cloudfront_media_cache_policy_id" {
  default = ""
}

variable "cloudfront_media_origin_request_policy_id" {
  default = ""
}


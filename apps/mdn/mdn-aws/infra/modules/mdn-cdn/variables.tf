variable "region" {
  default = "us-west-2"
}

variable enabled {}

variable environment {}

variable cloudfront_primary_enabled {}

variable cloudfront_primary_aliases {
  type = "list"
}

variable cloudfront_primary_distribution_name {
  default = "mdn-primary-cdn"
}

variable "cloudfront_primary_api_bucket" {}

variable acm_primary_cert_arn {}

variable cloudfront_primary_domain_name {}

variable cloudfront_attachments_enabled {}

variable cloudfront_attachments_aliases {
  type = "list"
}

variable cloudfront_attachments_distribution_name {
  default = "mdn-attachments-cdn"
}

variable cloudfront_attachments_domain_name {}

variable acm_attachments_cert_arn {}

variable "cloudfront_wiki_enabled" {}

variable "cloudfront_wiki_distribution_name" {
  default = "mdn-wiki-cdn"
}

variable "acm_wiki_cert_arn" {}

variable "cloudfront_wiki_aliases" {
  type = "list"
}

variable "cloudfront_wiki_origin_domain" {}

variable "cloudfront_media_enabled" {}

variable "cloudfront_media_aliases" {
  type = "list"
}

variable "acm_media_cert_arn" {}

variable "cloudfront_media_bucket" {}

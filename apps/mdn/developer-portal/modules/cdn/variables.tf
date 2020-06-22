variable "region" {
  default = "us-west-2"
}

variable "enabled" {
  default = true
}

variable "environment" {
}

variable "servicename" {
  default = "developer-portal"
}

variable "cdn_aliases" {
  type = list(string)
}

variable "logging_bucket" {
}

variable "certificate_arn" {
}

variable "cloudfront_protocol_policy" {
  default = "redirect-to-https"
}

variable "minimum_protocol_version" {
  default = "TLSv1.1_2016"
}

variable "cdn_compress" {
  default = true
}

variable "origin_domain_name" {
  description = "Domain name of the origin, typically a DNS name to the ELB"
  default     = ""
}

variable "origin_id" {
  description = "Just an origin identifier"
  default     = ""
}

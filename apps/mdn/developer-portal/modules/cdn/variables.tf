variable "region" {
  default = "us-west-2"
}

variable "enabled" {
  default = true
}

variable "environment" {}

variable "servicename" {
  default = "developer-portal"
}

variable "cdn_aliases" {
  type = "list"
}

variable "origin_bucket" {}

variable "logging_bucket" {}

variable "certificate_arn" {}

variable "cloudfront_protocol_policy" {
  default = "redirect-to-https"
}

variable "event_trigger" {
  default = "lambda-headers.handler"
}

variable "minimum_protocol_version" {
  default = "TLSv1.1_2016"
}

variable "cdn_compress" {
  default = true
}

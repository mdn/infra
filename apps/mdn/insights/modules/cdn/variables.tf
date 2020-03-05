variable "region" {
  default = "us-west-2"
}

variable "environment" {
}

variable "bucket_name" {
  default = "insights"
}

variable "servicename" {
  default = "insights"
}

variable "s3_versioning" {
  default = true
}

variable "cloudfront_enabled" {
  default = "true"
}

variable "cloudfront_aliases" {
  type = list(string)
}

variable "cloudfront_protocol_policy" {
  default = "redirect-to-https"
}

variable "enable_ipv6" {
  default = "true"
}

variable "acm_certificate_arn" {
}

variable "event_trigger" {
  default = "lambda-headers.handler"
}


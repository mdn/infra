variable "region" {
  default = "us-west-2"
}

variable "bucket-name" {
  default = "mdn-dev"
}

variable "servicename" {
  default = "mdn-dev"
}

variable "s3_versioning" {
  default = "true"
}

variable "cloudfront_enable" {
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


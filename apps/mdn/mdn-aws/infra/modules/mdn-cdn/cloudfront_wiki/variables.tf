variable "enabled" {}

variable "region" {
  default = "us-west-2"
}

variable "environment" {}

variable "aliases" {
  type = "list"
}

variable "enable_ipv6" {
  default = true
}

variable "distribution_name" {}

variable "acm_cert_arn" {}

variable "origin_domain" {}

variable "origin_read_timeout" {
  default = "120"
}

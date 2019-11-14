variable "region" {
  default = "us-west-2"
}

variable "enabled" {}

variable "environment" {}

variable "aliases" {
  type = "list"
}

variable "media_bucket" {}

variable "certificate_arn" {}

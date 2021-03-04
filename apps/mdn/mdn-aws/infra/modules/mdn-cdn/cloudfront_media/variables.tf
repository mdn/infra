variable "region" {
  default = "us-west-2"
}

variable "enabled" {
}

variable "environment" {
}

variable "aliases" {
  type = list(string)
}

variable "media_bucket" {
}

variable "certificate_arn" {
}

variable "cache_policy_id" {
  default = ""
}

variable "origin_request_policy_id" {
  default = ""
}

variable "default_cache_default_ttl" {
  default = 0
}

variable "default_cache_max_ttl" {
  default = 0
}

variable "default_cache_min_ttl" {
  default = 0
}


variable "region" {
  default = "us-west-2"
}

variable "cluster_oidc_issuer_url" {}

variable "service_account_namespace" {
  default = "mdn-cron"
}

variable "service_account_name" {
  default = "media-sync"
}

variable "stage_bucket" {}

variable "prod_bucket" {}

variable "region" {
  default = "us-west-2"
}

variable "bucket_name" {
}

variable "bucket_acl" {
  default = "private"
}

variable "eks_cluster_id" {}

variable "backups_sa" {
  default = "dev-portal-rds-backups"
}

variable "backups_namespace" {
  default = "dev-portal-prod"
}

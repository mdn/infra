variable "region" {
  default = "us-west-2"
}

variable "backup-bucket" {
  default = "mdn-rds-backup"
}

variable "bucket-acl" {
  default = "private"
}

variable "backup-user" {
  default = "rds-backup-user"
}

variable "eks_cluster_id" {}

variable "rds_backup_namespace" {
  default = "mdn-prod"
}

variable "rds_backup_sa" {
  default = "mdn-rds-backup"
}


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

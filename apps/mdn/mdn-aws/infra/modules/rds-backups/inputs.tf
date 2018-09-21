variable "region" {
  default = "us-west-2"
}

variable "backup-bucket" {
  default = "mdn-backup-bucket"
}

variable "bucket-acl" {
  default = "private"
}

variable "backup-user" {
  default = "rds-backup-user"
}

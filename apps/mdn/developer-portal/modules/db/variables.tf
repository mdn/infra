variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {}

variable "environment" {}

variable "identifier" {}

variable "db_storage" {
  default = "100"
}

variable "db_storage_type" {
  default = "gp2"
}

variable "db_port" {
  default = "5432"
}

variable "engine_version" {
  default = "11.4"
}

variable "instance_class" {}

variable "db_name" {}

variable "db_user" {}

variable "db_password" {}

variable "multi_az" {
  default = true
}

variable "backup_retention_days" {
  default = 7
}

variable "backup_window" {
  default = "00:00-00:30"
}

variable "maintenance_window" {
  default = "Sun:00:31-Sun:01:01"
}

variable "storage_encrypted" {
  default = true
}

variable "allow_minor_version_upgrade" {
  default = true
}

variable "allow_major_version_upgrade" {
  default = false
}

variable "monitoring_interval" {
  default = "0"
}

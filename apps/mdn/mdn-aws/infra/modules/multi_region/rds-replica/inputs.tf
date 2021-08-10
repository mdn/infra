variable "region" {
}

variable "environment" {
}

variable "enabled" {
  default = true
}

variable "replica_identifier" {
  default = "mdn"
}

variable "instance_class" {
  default = "db.t3.small"
}

variable "storage_type" {
  default = "gp2"
}

variable "replica_source_db" {
}

variable "subnet_type" {
  default = "Public"
}

variable "kms_key_id" {
}

variable "vpc_id" {
}

variable "multi_az" {
  default = true
}

variable "mysql_port" {
  default = "3306"
}

variable "postgres_port" {
  default = 5432
}

variable "monitoring_interval" {
  default = "0"
}

variable "postgres_replica_source_db" {}

variable "postgres_instance_class" {
  default = "db.m5.large"
}

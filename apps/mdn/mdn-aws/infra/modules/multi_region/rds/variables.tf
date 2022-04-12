variable "region" {
  default = "us-west-2"
}

variable "enabled" {
  default = true
}

variable "rds_security_group_name" {
}

variable "rds_security_group_id" {
  default = ""
  description = "security_group_id"
}

variable "rds_subnet_group_name" {
  default = ""
  description = "security_group_name"
}

variable "postgres_port" {
  default     = 5432
  description = "ingress port to open"
}

variable "postgres_storage_gb" {
  default = 200
}

variable "postgres_allow_major_version_upgrade" {
  default = false
}

variable "postgres_auto_minor_version_upgrade" {
  default = true
}

variable "postgres_backup_window" {
  default = "00:00-00:30"
}

variable "postgres_backup_retention_days" {
  default = 7
}

variable "postgres_engine" {
  default = "postgres"
}

variable "postgres_engine_version" {
  default = "13.3"
}

variable "postgres_identifier" {}

variable "postgres_instance_class" {
  default     = "db.m5.xlarge"
  description = "Instance class"
}

variable "postgres_maintenance_window" {
  default = "sun:00:31-sun:01:01"
}

variable "postgres_db_name" {}

variable "postgres_password" {}

variable "postgres_storage_encrypted" {
  default = true
}

variable "postgres_storage_type" {
  default = "io1"
}

variable "postgres_username" {}

variable "vpc_id" {
}

variable "environment" {
}

variable "subnet_type" {
  default = "Public"
}

variable "monitoring_interval" {
  default = "0"
}

variable "performance_insights_enabled" {
  default = true
}


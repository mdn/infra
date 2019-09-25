variable "mysql_db_name" {}

variable "mysql_username" {}

variable "mysql_password" {}

variable "mysql_identifier" {}

variable "mysql_env" {}

variable "mysql_security_group_name" {}

variable "mysql_storage_gb" {
  default     = "100"
  description = "Storage size in GB"
}

variable "mysql_instance_class" {
  default     = "db.m3.xlarge"
  description = "Instance class"
}

variable "mysql_port" {
  default     = 3306
  description = "ingress port to open"
}

variable "mysql_engine" {
  default     = "mysql"
  description = "Engine type, example values mysql, postgres"
}

variable "mysql_engine_version" {
  description = "Engine version"
  default     = "5.6.35"
}

variable "mysql_storage_type" {
  default = "gp2"
}

variable "mysql_backup_retention_days" {
  default = 7
}

variable "mysql_backup_window" {
  default = "00:00-00:30"
}

variable "mysql_maintenance_window" {
  default = "Sun:00:31-Sun:01:01"
}

variable "mysql_storage_encrypted" {
  default = true
}

variable "mysql_auto_minor_version_upgrade" {
  default = true
}

variable "mysql_allow_major_version_upgrade" {
  default = false
}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "enabled" {}

variable "environment" {}

variable "region" {}

variable "subnets" {}

variable "monitoring_interval" {
  default = "0"
}

variable "performance_insights_enabled" {
  default = true
}

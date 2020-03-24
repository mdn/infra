variable "region" {
  default = "us-west-2"
}

variable "environment" {
}

variable "efs_name" {
}

variable "subnets" {
}

variable "nodes_security_group" {
  type = list(string)
}

variable "enabled" {
}

variable "performance_mode" {
  default = "generalPurpose"
}


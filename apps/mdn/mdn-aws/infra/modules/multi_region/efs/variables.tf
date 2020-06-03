variable "region" {
  default = "us-west-2"
}

variable "environment" {
}

variable "efs_name" {
}

variable "vpc_id" {}

variable "subnets" {
  type = list(string)
}

variable "nodes_security_group" {
  type    = list(string)
  default = []
}

variable "enabled" {
  default = true
}

variable "performance_mode" {
  default = "generalPurpose"
}


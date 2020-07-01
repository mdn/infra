variable "region" {
  default = "us-west-2"
}

variable "enabled" {
  default = true
}

variable "environment" {
}

variable "redis_name" {
}

variable "redis_node_size" {
}

variable "redis_port" {
  default = 6379
}

variable "vpc_id" {}

variable "subnet_type" {
  default = "Public"
}

variable "redis_num_nodes" {
  default = 1
}

variable "redis_automatic_failover" {
  default = true
}

variable "redis_param_group" {
  default = "default.redis5.0"
}

variable "redis_engine_version" {
  default = "5.0.6"
}

variable "nodes_security_group" {
  type    = list(string)
  default = []
}

variable "azs" {
  type = list(string)
}


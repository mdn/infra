variable "region" {
  default = "us-west-2"
}

variable "environment" {
}

variable "redis_id" {
}

variable "redis_engine" {
  default = "5.0.5"
}

variable "redis_port" {
  default = "6379"
}

variable "redis_node_type" {
  default = "cache.t2.small"
}

variable "redis_param_group" {
  default = "default.redis5.0"
}

variable "redis_nodes" {
  default = "1"
}

variable "vpc_id" {}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}


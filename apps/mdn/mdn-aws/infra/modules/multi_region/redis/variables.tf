variable "region" {
  default = "us-west-2"
}

variable "environment" {}

variable "redis_name" {}
variable "redis_node_size" {}

variable "redis_port" {
  default = 6379
}

variable "redis_num_nodes" {
  default = 1
}

variable "redis_param_group" {
  default = "default.redis3.2"
}

variable "redis_engine_version" {
  default = "3.2.4"
}

variable "subnets" {}

variable "nodes_security_group" {
  type = "list"
}

variable "enabled" {}

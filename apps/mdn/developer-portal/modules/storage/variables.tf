variable "region" {
  default = "us-west-2"
}

variable "environment" {}

variable "subnets" {
  type = "list"
}

variable "nodes_security_group" {
  type = "list"
}

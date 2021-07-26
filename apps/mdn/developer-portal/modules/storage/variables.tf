variable "region" {
  default = "us-west-2"
}

variable "environment" {
}

variable "subnets" {
  type = list(string)
}

variable "nodes_security_group" {
  type = list(string)
}

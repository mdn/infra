variable "region" {
  default = "us-west-2"
}

variable "vpc_name" {
  default = "main-vpc"
}

variable "vpc_id" {}

variable "igw_id" {}

variable "tags" {
  type = "map"
}

variable "azs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "private_subnet_cidrs" {
  type    = "list"
  default = []
}

variable "region" {
  default = "us-west-2"
}

variable "create_vpc" {
  default = true
}

variable "vpc_name" {
  default = "main-vpc"
}

# Temporarily here
variable "vpc_id" {}

variable "azs" {
  type = "list"
}

# Temporary
variable "public_subnets" {
  type = "list"
}

variable "private_subnets_cidr" {
  type    = "list"
  default = []
}

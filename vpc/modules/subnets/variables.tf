variable "region" {
  default = "us-west-2"
}

variable "vpc_name" {
  default = "main-vpc"
}

variable "vpc_id" {
}

variable "igw_id" {
}

variable "tags" {
  type = map(string)
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_map_public_ip_on_launch" {
  default = true
}

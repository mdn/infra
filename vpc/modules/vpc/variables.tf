
variable "region" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "172.20.0.0/16"
}

variable "tags" {
  type = "map"
}

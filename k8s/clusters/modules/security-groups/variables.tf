variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {}

variable "ip_whitelist" {
  type    = list(string)
  default = []
}

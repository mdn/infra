variable "enabled" {
  default = true
}

variable "name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "certificate_arn" {}

variable "ingress_nginx_settings" {
  type    = map(string)
  default = {}
}

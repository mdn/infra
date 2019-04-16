variable "region" {
  default = "us-west-2"
}

variable "create_destination_bucket" {
  default = true
}

variable "lambda_debug" {
  default = "False"
}

variable "source_bucket" {}

variable "destination_bucket" {}

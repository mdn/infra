variable "region" {
  default = "us-west-2"
}

variable "environment" {
}

variable "create_user" {
  default = false
}

variable "name" {
  default = "mdn-uploader"
}

variable "iam_policies" {
  type = list(string)
}


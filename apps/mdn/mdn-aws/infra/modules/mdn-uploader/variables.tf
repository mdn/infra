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

variable "eks_worker_role_arn" {
  type = list(string)
}

variable "iam_policies" {
  type = list(string)
}


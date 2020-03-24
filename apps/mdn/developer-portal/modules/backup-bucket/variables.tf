variable "region" {
  default = "us-west-2"
}

variable "bucket_name" {
}

variable "bucket_acl" {
  default = "private"
}

variable "eks_worker_role_arn" {
  type = list(string)
}

variable "create_user" {
  default = false
}


variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {}

variable "cluster_version" {
  default = "1.12"
}

variable "lifecycled_log_group" {
  default = "/aws/lifecycled"
}

variable "vpc_id" {}

variable "eks_subnets" {
  type = "list"
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers_group_defaults for valid keys."
  type        = "list"

  default = [
    {
      "name" = "default"
    },
  ]
}

variable "worker_group_count" {
  description = "The number of maps contained within the worker_groups list."
  type        = "string"
  default     = "1"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type        = "list"
  default     = []
}

variable "map_roles_count" {
  description = "The count of roles in the map_roles list."
  type        = "string"
  default     = 0
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type        = "list"
  default     = []
}

variable "map_users_count" {
  description = "The count of roles in the map_users list."
  type        = "string"
  default     = 0
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = "map"
  default     = {}
}

variable "enable_kube2iam" {
  description = "Boolean to create kube2iam iam roles"
  default     = true
}

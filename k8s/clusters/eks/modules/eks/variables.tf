variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {
}

variable "cluster_version" {
  default = "1.12"
}

variable "lifecycled_log_group" {
  default = "/aws/lifecycled"
}

variable "vpc_id" {
}

variable "eks_subnets" {
  type = list(string)
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers_group_defaults for valid keys."
  type        = any

  default = [
    {
      "name" = "default"
    },
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type        = list(map(string))
  default     = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type        = list(map(string))
  default     = []
}


variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "enable_kube2iam" {
  description = "Boolean to create kube2iam iam roles"
  default     = true
}


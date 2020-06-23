variable "eks_cluster_id" {}

variable "papertrail_settings" {
  type    = map(string)
  default = {}
}

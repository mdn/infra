variable "telegraf_namespace" {
  type        = string
  description = "namespace for telegraf deployment"
  default     = "telegraf"
}

variable "telegraf_config_secret_name" {
  type        = string
  description = "name for telegraf config secret"
  default     = "telegraf-config"
}

variable "service_name" {
  type        = string
  description = "name of the service that's going to write metrics to this instance"
}

variable "cluster_name" {
  type        = string
  description = "name of k8s cluster the chart is going to be deployed to"
}

variable "cluster_region" {
  type        = string
  description = "region of k8s cluster the chart is going to be deployed to"
}

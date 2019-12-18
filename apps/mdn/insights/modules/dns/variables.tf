variable "domain-zone-id" {}

variable "domain-name" {}

variable "domain-name-alias" {}

variable "evaluate-target-health" {
  default = "true"
}

variable "domain-ttl" {
  default = "300"
}

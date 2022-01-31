variable "region" {
  description = "region to deploy cloudfront distribution"
  type        = string
}

variable "environment" {
  description = "environment for interactive examples cloudfront distribution"
  type        = string
}

variable "acm_cert_arn" {
  description = "arn for associated cloud distribution"
  type        = string
}

variable "expiration_days" {
  description = "Number of days to hold object before expiring"
  default     = 90
}

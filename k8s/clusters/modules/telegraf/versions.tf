terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0, < 2.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13.1, < 2.14"
    }
  }
  required_version = ">= 1.2.9, < 1.3"
}

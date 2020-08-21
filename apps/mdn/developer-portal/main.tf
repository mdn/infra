provider "aws" {
  version = "~> 2"
  region  = var.region
}

module "backup_bucket" {
  source         = "./modules/backup-bucket"
  bucket_name    = "developer-portal-backups"
  eks_cluster_id = data.terraform_remote_state.eks-us-west-2.outputs.mdn_apps_a_cluster_name
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/eu-central-1/eks"
    region = "us-west-2"
  }
}

module "ssh_sg" {
  source = "../modules/security-groups"
  region = var.region
  vpc_id = data.terraform_remote_state.vpc-eu-central-1.outputs.vpc_id
}

module "mdn" {
  source = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"

  region          = var.region
  vpc_id          = data.terraform_remote_state.vpc-eu-central-1.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.vpc-eu-central-1.outputs.public_subnets

  cluster_name       = "mdn"
  cluster_version    = "1.21"
  cluster_features   = local.cluster_features
  node_groups        = local.mdn_node_groups
  map_roles          = local.map_roles
  velero_bucket_name = local.velero_bucket_name
}

module "jenkins-rbac" {

  providers = {
    kubernetes = kubernetes.mdn
  }

  source    = "../modules/jenkins-rbac"
  namespace = ["mdn-prod"]
}

module "papertrail" {

  providers = {
    helm = helm.mdn
  }

  source         = "../modules/papertrail"
  eks_cluster_id = module.mdn.cluster_id
}

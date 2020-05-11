terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

module "mdn-jenkins-rbac" {
  source    = "../modules/jenkins-rbac"
  namespace = ["mdn-stage", "mdn-prod"]
  providers = {
    kubernetes = kubernetes.mdn
  }
}

module "mdn" {
  source = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"

  region          = var.region
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name       = "mdn"
  cluster_version    = "1.16"
  node_groups        = local.mdn_node_groups
  map_roles          = local.map_roles
  velero_bucket_name = "velero-${module.mdn.cluster_id}-${var.region}-${data.aws_caller_identity.current.account_id}"
}

module "mdn-apps-a" {
  source = "../modules/eks"

  region      = var.region
  vpc_id      = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  eks_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name    = "mdn-apps-a"
  cluster_version = "1.14"
  node_groups     = local.mdn_apps_node_groups
  map_roles       = local.map_roles
  map_users       = local.map_users
  tags            = local.cluster_tags
}


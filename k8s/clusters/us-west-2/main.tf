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

module "ssh_sg" {
  source = "../modules/security-groups"
  region = var.region
  vpc_id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
}

module "papertrail-mdn" {
  providers = {
    helm = helm.mdn
  }

  source         = "../modules/papertrail"
  eks_cluster_id = module.mdn.cluster_id
}

module "ingress-nginx-mdn" {
  providers = {
    helm = helm.mdn
  }

  source          = "../modules/nginx-ingress"
  certificate_arn = data.aws_acm_certificate.redirects.arn
}

module "mdn" {
  source = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"

  region          = var.region
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name       = "mdn"
  cluster_version    = "1.20"
  cluster_features   = local.cluster_features
  node_groups        = local.mdn_node_groups
  map_roles          = local.map_roles
  velero_bucket_name = "velero-${module.mdn.cluster_id}-${var.region}-${data.aws_caller_identity.current.account_id}"
}

module "telegraf" {
  providers = {
    helm       = helm.mdn
    kubernetes = kubernetes.mdn
  }

  source = "../modules/telegraf"

  service_name   = "mdn"
  cluster_name   = "mdn"
  cluster_region = var.region
}

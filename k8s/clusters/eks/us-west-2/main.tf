terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

locals {

  mdn_apps_node_groups = {
    default_ng = {
      desired_capacity = "4"
      min_capacity     = "3"
      max_capacity     = "12"
      disk_size        = "50"
      instance_type    = "m5.large"
      subnets          = data.terraform_remote_state.vpc-us-west-2.outputs.private_subnets

      k8s_label = {
        Service = "default"
        Node    = "managed"
      }

      additional_tags = {
        "Name"                              = "mdn-apps-a-default-ng"
        "kubernetes.io/cluster/mdn-apps-a"  = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  }

  mdn_node_groups = {
    default_ng = {
      desired_capacity = "1"
      min_capacity     = "1"
      max_capacity     = "3"
      disk_size        = "100"
      instance_type    = "t3.small"
      subnets          = data.terraform_remote_state.vpc-us-west-2.outputs.private_subnets

      k8s_label = {
        Service = "default"
        Node    = "managed"
      }

      additional_tags = {
        "Name"                              = "mdn-default-ng"
        "kubernetes.io/cluster/mdn"         = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  }

  map_roles = [
    {
      username = "itsre-admin"
      rolearn  = "arn:aws:iam::178589013767:role/itsre-admin"
      groups   = ["system:masters"]
    },
    {
      username = "maws-admin"
      rolearn  = "arn:aws:iam::178589013767:role/maws-admin"
      groups   = ["system:masters"]
    },
    {
      username = "AdminRole"
      # This is a bug in k8s, the role in IAM will not match this
      # file since k8s has issues parsing roles with paths
      rolearn = "arn:aws:iam::178589013767:role/AdminRole"
      groups  = ["system:masters"]
    },
    {
      username = "jenkins"
      rolearn  = "arn:aws:iam::178589013767:role/ci-mdn-us-west-2"
      groups   = ["jenkins-access"]
    },
  ]

  map_users = [
    {
      username = "sjalim"
      userarn  = "arn:aws:iam::178589013767:user/sjalim"
      groups   = ["jenkins-access"]
    },
  ]

  cluster_tags = {
    Region    = var.region
    Terraform = "true"
  }
}

module "mdn" {
  source = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"

  region          = var.region
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name    = "mdn"
  cluster_version = "1.15"
  node_groups     = local.mdn_node_groups
  map_roles       = local.map_roles

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


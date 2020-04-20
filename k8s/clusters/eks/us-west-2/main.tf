terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

locals {
  mdn_apps_workers = [
    {
      instance_type        = "m5.large"
      key_name             = "mdn"
      subnets              = data.terraform_remote_state.vpc-us-west-2.outputs.private_subnets,
      autoscaling_enabled  = true
      asg_desired_capacity = 5
      asg_min_size         = 5
      asg_max_size         = 12
      spot_price           = "0.06"
      additional_userdata  = data.template_file.additional_userdata.rendered

      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "value"               = "true"
          "propagate_at_launch" = "true"
        }
      ]
    }
  ]

  mdn_apps_node_groups = {
    default_ng = {
      desired_capacity = "2"
      min_capacity     = "2"
      max_capacity     = "5"
      disk_size        = "100"
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

data "template_file" "additional_userdata" {
  template = file("${path.module}/templates/userdata/additional-userdata.sh")
}

module "mdn-apps-a" {
  source = "../modules/eks"

  region      = var.region
  vpc_id      = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  eks_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name    = "mdn-apps-a"
  cluster_version = "1.14"
  worker_groups   = local.mdn_apps_workers
  node_groups     = local.mdn_apps_node_groups
  map_roles       = local.map_roles
  map_users       = local.map_users
  tags            = local.cluster_tags
}


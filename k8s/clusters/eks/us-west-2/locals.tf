
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
      disk_size        = "50"
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


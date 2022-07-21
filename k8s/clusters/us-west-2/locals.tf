locals {

  cluster_features = {
    "aws_calico"  = true
    "alb_ingress" = true
    "reloader"    = false
  }

  mdn_node_groups = {
    blue-workers = {
      name = "mdn-blue-workers"

      desired_capacity = "4"
      min_capacity     = "4"
      max_capacity     = "12"
      disk_size        = "100"
      instance_types   = ["m5.xlarge"]
      subnets          = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets
      ami_id           = "ami-0aa4096ec49a62235"

      k8s_label = {
        Service = "default"
        Node    = "managed"
      }

      additional_tags = {
        "Name"                              = "mdn-blue-workers"
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
      username = "maws-mdn-admin"
      rolearn  = "arn:aws:iam::178589013767:role/maws-mdn-admin"
      groups   = ["system:masters"]
    },
    {
      username = "jenkins"
      rolearn  = "arn:aws:iam::178589013767:role/ci-mdn-us-west-2"
      groups   = ["jenkins-access"]
    },
  ]

  cluster_tags = {
    Region    = var.region
    Terraform = "true"
  }
}

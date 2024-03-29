locals {

  cluster_features = {
    # aws_calico migrated to calico
    # installed with helm manually in the cluster
    "aws_calico"       = false
    "alb_ingress"      = false
    "reloader"         = false
    "external_secrets" = false
  }

  velero_bucket_name = "velero-${module.mdn.cluster_id}-${var.region}-${data.aws_caller_identity.current.account_id}"

  mdn_node_groups = {
    green-workers = {
      name = "mdn-green-workers"

      desired_capacity = "2"
      min_capacity     = "2"
      max_capacity     = "12"
      disk_size        = "50"
      instance_types   = ["m5.large"]
      subnets          = data.terraform_remote_state.vpc-eu-central-1.outputs.public_subnets

      k8s_label = {
        Service = "default"
        Node    = "managed"
      }

      additional_tags = {
        "Name"                              = "mdn-green-workers"
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

locals {

  cluster_features = {
    "aws_calico" = true
  }

  velero_bucket_name = "velero-${module.mdn.cluster_id}-${var.region}-${data.aws_caller_identity.current.account_id}"

  mdn_node_groups = {
    default_ng_1 = {
      desired_capacity          = "3"
      min_capacity              = "3"
      max_capacity              = "12"
      disk_size                 = "50"
      instance_type             = "m5.large"
      key_name                  = "mdn"
      source_security_group_ids = [module.ssh_sg.ssh_security_group_id]
      subnets                   = data.terraform_remote_state.vpc-eu-central-1.outputs.public_subnets

      k8s_label = {
        Service = "default"
        Node    = "managed"
      }

      additional_tags = {
        "Name"                              = "mdn-default-ng-1"
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

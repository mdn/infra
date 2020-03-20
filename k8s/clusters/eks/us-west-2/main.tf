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
    },
  ]

  map_roles = [
    {
      username = "itsre-admin"
      role_arn = "arn:aws:iam::178589013767:role/itsre-admin"
      group    = "system:masters"
    },
    {
      username = "AdminRole"
      # This is a bug in k8s, the role in IAM will not match this
      # file since k8s has issues parsing roles with paths
      role_arn = "arn:aws:iam::178589013767:role/AdminRole"
      group    = "system:masters"
    },
    {
      username = "jenkins"
      role_arn = "arn:aws:iam::178589013767:role/ci-mdn-us-west-2"
      group    = "jenkins-access"
    },
  ]

  map_users = [
    {
      username = "sjalim"
      user_arn = "arn:aws:iam::178589013767:user/sjalim"
      group    = "jenkins-access"
    },
  ]

  cluster_tags = {
    Region                              = var.region
    Terraform                           = "true"
    "k8s.io/cluster-autoscaler/enabled" = "true"
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
  map_roles       = local.map_roles
  map_users       = local.map_users
  tags            = local.cluster_tags
}


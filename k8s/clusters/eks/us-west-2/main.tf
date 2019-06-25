terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

locals {
  developer_portal_workers = [
    {
      instance_type        = "m5.large"
      key_name             = "mdn"
      subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.private_subnets)}"
      autoscaling_enabled  = true
      asg_desired_capacity = 3
      asg_min_size         = 3
      asg_max_size         = 5
      spot_price           = "0.07"
      additional_userdata  = "${data.template_file.additional_userdata.rendered}"
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

      group = "system:masters"
    },
    {
      username = "jenkins"
      role_arn = "arn:aws:iam::178589013767:role/ci-mdn-us-west-2"
      group    = "jenkins-access"
    },
  ]

  cluster_tags = {
    Region    = "${var.region}"
    Terraform = "true"
  }
}

data "template_file" "additional_userdata" {
  template = "${file("${path.module}/templates/userdata/additional-userdata.sh")}"
}

module "k8s-developer-portal" {
  source = "../modules/eks"

  region      = "${var.region}"
  vpc_id      = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
  eks_subnets = "${data.terraform_remote_state.vpc-us-west-2.public_subnets}"

  cluster_name       = "k8s-developer-portal"
  cluster_version    = "${var.cluster_version}"
  worker_groups      = "${local.developer_portal_workers}"
  worker_group_count = "1"
  map_roles          = "${local.map_roles}"
  map_roles_count    = "3"
  tags               = "${local.cluster_tags}"
}

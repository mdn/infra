terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

locals {
  sandbox_cluster_name = "sandbox-${random_string.suffix.result}"

  workers = [
    {
      name                 = "worker-a"
      instance_type        = "t2.medium"
      key_name             = "mdn"
      subnets              = "${join(",", data.terraform_remote_state.vpc-us-west-2.private_subnets)}"
      asg_desired_capacity = 3
      asg_max_size         = 5
      spot_price           = "0.04"
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
      username = "rjohnson"
      role_arn = "arn:aws:iam::178589013767:role/nubis/admin/rjohnson"
      group    = "system:masters"
    },
  ]

  cluster_tags = {
    Region      = "${var.region}"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

data "template_file" "additional_userdata" {
  template = "${file("${path.module}/userdata/additional-userdata.sh")}"
}

resource "aws_security_group" "worker_group_mgmt_us-west-2" {
  vpc_id      = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"
  description = "Allow management of worker groups"

  ingress {
    to_port   = 22
    from_port = 22
    protocol  = "tcp"

    cidr_blocks = ["${data.aws_vpc.us-west-2.cidr_block}"]
  }

  tags = "${merge(map("Name", "worker_sg"), local.cluster_tags)}"
}

module "sandbox-eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "3.0.0"

  cluster_name    = "${local.sandbox_cluster_name}"
  cluster_version = "${var.cluster_version}"
  vpc_id          = "${data.terraform_remote_state.vpc-us-west-2.vpc_id}"

  worker_groups                        = "${local.workers}"
  worker_group_count                   = "${length(local.workers)}"
  tags                                 = "${local.cluster_tags}"
  map_roles                            = "${local.map_roles}"
  map_roles_count                      = "${length(local.map_roles)}"
  worker_additional_security_group_ids = ["${aws_security_group.worker_group_mgmt_us-west-2.id}"]
  write_kubeconfig                     = "false"
  write_aws_auth_config                = "false"
  manage_aws_auth                      = "true"
  subnets                              = ["${data.terraform_remote_state.vpc-us-west-2.public_subnets}"]
}

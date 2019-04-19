provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/eu-central-1/vpc"
    region = "us-west-2"
  }
}

locals {
  public_subnet_cidrs  = ["172.20.32.0/19", "172.20.64.0/19", "172.20.96.0/19"]
  private_subnet_cidrs = ["172.20.128.0/19", "172.20.160.0/19", "172.20.192.0/19"]

  vpc_tags = {
    Name                                                      = "k8s.eu-central-1a.mdn.mozit.cloud"
    KubernetesCluster                                         = "k8s.eu-central-1a.mdn.mozit.cloud"
    "kubernetes.io/cluster/k8s.eu-central-1a.mdn.mozit.cloud" = "owned"
  }

  subnet_tags = {
    "kubernetes.io/cluster/k8s.eu-central-1a.mdn.mozit.cloud" = "owned"
  }
}

module "vpc-eu-central-1" {
  source   = "../modules/vpc"
  region   = "${var.region}"
  vpc_cidr = "172.20.0.0/16"

  tags = "${local.vpc_tags}"
}

module "subnets-eu-central-1" {
  source               = "../modules/subnets"
  vpc_id               = "${module.vpc-eu-central-1.vpc_id}"
  igw_id               = "${module.vpc-eu-central-1.igw_id}"
  azs                  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnet_cidrs  = "${local.public_subnet_cidrs}"
  private_subnet_cidrs = "${local.private_subnet_cidrs}"
  tags                 = "${local.subnet_tags}"
}

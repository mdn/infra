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
  vpc_id              = "vpc-0a0645faca1563b3b"
  private_subnet_cidr = ["172.20.128.0/19", "172.20.160.0/19", "172.20.192.0/19"]
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = "${local.vpc_id}"

  tags = {
    SubnetType = "Public"
  }
}

module "subnets-eu-central-1" {
  source               = "../modules/subnets"
  vpc_id               = "${local.vpc_id}"
  azs                  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets       = ["${data.aws_subnet_ids.public_subnets.ids}"]
  private_subnets_cidr = "${local.private_subnet_cidr}"
}

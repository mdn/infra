provider "aws" {
  alias  = "data-eu-central-1"
  region = "eu-central-1"
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/dns"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "vpc-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/vpc"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "vpc-eu-central-1" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/eu-central-1/vpc"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "eks-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "eks-eu-central-1" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/eu-central-1/eks"
    region = "us-west-2"
  }
}

data "aws_vpc" "cidr" {
  id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
}

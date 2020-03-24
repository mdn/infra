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

data "terraform_remote_state" "kops-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-us-west-2a"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "kops-eu-central-1" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-eu-central-1a"
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

data "aws_vpc" "cidr" {
  id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
}

data "aws_security_groups" "us-west-2-nodes_sg" {
  filter {
    name   = "group-name"
    values = ["nodes.k8s.us-west-2*"]
  }

  filter {
    name = "vpc-id"
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    values = [data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id]
  }
}

data "aws_security_groups" "eu-central-1-nodes_sg" {
  provider = aws.data-eu-central-1

  filter {
    name   = "group-name"
    values = ["nodes.k8s.eu-central-1*"]
  }

  filter {
    name = "vpc-id"
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    values = [data.terraform_remote_state.vpc-eu-central-1.outputs.vpc_id]
  }
}


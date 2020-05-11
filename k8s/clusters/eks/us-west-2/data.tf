data "terraform_remote_state" "vpc-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/vpc"
    region = "us-west-2"
  }
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "us-west-2" {
  id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
}

data "aws_eks_cluster" "mdn" {
  name = module.mdn.cluster_id
}

data "aws_eks_cluster_auth" "mdn" {
  name = module.mdn.cluster_id
}

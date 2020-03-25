data "terraform_remote_state" "vpc-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/vpc"
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

data "terraform_remote_state" "kops-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-us-west-2a"
    region = "us-west-2"
  }
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

data "aws_acm_certificate" "developer-portal-cdn-dev" {
  provider = aws.acm
  domain   = "developer-portal.dev.mdn.mozit.cloud"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "developer-portal-cdn-stage" {
  provider = aws.acm
  domain   = "developer-portal.stage.mdn.mozit.cloud"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "developer-portal-cdn-prod" {
  provider = aws.acm
  domain   = "developer-portal.prod.mdn.mozit.cloud"
  statuses = ["ISSUED"]
}


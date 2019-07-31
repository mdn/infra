data terraform_remote_state "vpc-us-west-2" {
  backend = "s3"

  config {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/vpc"
    region = "us-west-2"
  }
}

data terraform_remote_state "eks-us-west-2" {
  backend = "s3"

  config {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

data terraform_remote_state "kops-us-west-2" {
  backend = "s3"

  config {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-us-west-2a"
    region = "us-west-2"
  }
}

data terraform_remote_state "kubernetes-us-west-2" {
  backend = "s3"

  config {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-us-west-2a"
    region = "us-west-2"
  }
}

data aws_subnet_ids "subnet_id" {
  vpc_id = "${data.terraform_remote_state.kubernetes-us-west-2.vpc_id}"
}

data aws_ami "centos" {
  most_recent = true

  filter {
    name = "product-code"

    # Grabbed from https://wiki.centos.org/Cloud/AWS
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]
}

data aws_acm_certificate "mdn-samples" {
  domain   = "mdn-samples.us-west-2.mdn.mozit.cloud"
  statuses = ["ISSUED"]
}

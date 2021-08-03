# NOTE: Not ideal way of doing this

provider "aws" {
  region = "us-west-2"
}

data "aws_network_acls" "us-west-2-nacl" {
  vpc_id = var.us-west-2-vpc-id

  tags = {
    Service = "MDN"
  }
}

data "aws_caller_identity" "current" {
}

locals {
  # This is a crappy way to do this, we are assuming that there is only
  # one nacl. Instead there might be multiple nacls but we are taking
  # the first one only
  nacl_id  = element(tolist(data.aws_network_acls.us-west-2-nacl.ids), 0)
  nacl_arn = "arn:aws:ec2:us-west-2:${data.aws_caller_identity.current.account_id}:network-acl/${local.nacl_id}"
}

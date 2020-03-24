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

resource "aws_iam_user" "worf" {
  name = var.security-user
}

resource "aws_iam_access_key" "worf-keys" {
  user = aws_iam_user.worf.name
}


locals {
  # This is a crappy way to do this, we are assuming that there is only
  # one nacl. Instead there might be multiple nacls but we are taking
  # the first one only
  nacl_id  = element(tolist(data.aws_network_acls.us-west-2-nacl.ids), 0)
  nacl_arn = "arn:aws:ec2:us-west-2:${data.aws_caller_identity.current.account_id}:network-acl/${local.nacl_id}"
}

data "aws_iam_policy_document" "worf_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteNetworkAclEntry"
    ]
    resources = [
      local.nacl_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:ReplaceNetworkAclEntry",
      "ec2:CreateNetworkAclEntry",
      "ec2:DescribeNetworkAcls"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "worf-policy" {
  name = "worf-policy"
  user = aws_iam_user.worf.name

  policy = data.aws_iam_policy_document.worf_policy.json
}


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

data "aws_eks_cluster" "worf" {
  name = var.eks_cluster_id
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.10.0"
  create_role                   = true
  role_name                     = "worf"
  provider_url                  = replace(data.aws_eks_cluster.worf.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.worf.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:worf:worf"]
}

resource "aws_iam_policy" "worf" {
  name_prefix = "worf-policy-"
  description = "EKS worf policy for cluster ${var.eks_cluster_id}"
  policy      = data.aws_iam_policy_document.worf_policy.json
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

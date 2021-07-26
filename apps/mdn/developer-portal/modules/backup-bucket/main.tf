locals {
  bucket_name = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  role_name   = "${var.bucket_name}-role"
  policy_name = "${var.bucket_name}-policy"
}

data "aws_caller_identity" "current" {
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  acl    = var.bucket_acl

  tags = {
    Name      = local.bucket_name
    Project   = "developer-portal"
    Terraform = "true"
  }
}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.10.0"
  create_role                   = true
  role_name                     = local.role_name
  provider_url                  = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.this.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.backups_namespace}:${var.backups_sa}"]
}

resource "aws_iam_policy" "this" {
  name_prefix = "${local.policy_name}-"
  description = "EKS rds backup policy for ${var.eks_cluster_id}"
  policy      = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowUserToListBuckets"
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = ["arn:aws:s3:::*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

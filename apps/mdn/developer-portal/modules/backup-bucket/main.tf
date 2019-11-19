locals {
  bucket_name  = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  iam_username = "${var.bucket_name}-user"
  role_name    = "${var.bucket_name}-role"
  policy_name  = "${var.bucket_name}-policy"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket = "${local.bucket_name}"
  acl    = "${var.bucket_acl}"

  tags {
    Name      = "${local.bucket_name}"
    Project   = "developer-portal"
    Terraform = "true"
  }
}

resource "aws_iam_role" "this" {
  name               = "${local.role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.bucket_role.json}"

  tags {
    Name      = "${local.role_name}"
    Project   = "developer-portal"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${local.policy_name}"
  role   = "${aws_iam_role.this.id}"
  policy = "${data.aws_iam_policy_document.bucket_policy.json}"
}

resource "aws_iam_user" "this" {
  count = "${var.create_user}"
  name  = "${local.iam_username}"
}

resource "aws_iam_user_policy" "this" {
  count  = "${var.create_user}"
  name   = "${local.policy_name}"
  user   = "${element(aws_iam_user.this.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.bucket_policy.json}"
}

resource "aws_iam_access_key" "this" {
  count = "${var.create_user}"
  user  = "${element(aws_iam_user.this.*.name, count.index)}"
}

data "aws_iam_policy_document" "bucket_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    # We assume you are using kube2iam here
    principals {
      type        = "AWS"
      identifiers = ["${var.eks_worker_role_arn}"]
    }
  }
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

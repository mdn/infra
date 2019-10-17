locals {
  bucket_name = "${var.bucket_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"

  # All other things reference this
  identifier   = "${var.bucket_name}-${var.environment}"
  media_bucket = "${var.bucket_name}-${var.environment}-media-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "this" {
  bucket = "${local.bucket_name}"
  acl    = "${var.bucket_acl}"
  policy = "${data.aws_iam_policy_document.bucket_public_policy.json}"

  #cors_rule {
  #  allowed_headers = ["*"]
  #  allowed_methods = ["GET"]
  #  allowed_origins = ["*"]
  #  max_age_seconds = 3000
  #}

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags {
    Name        = "${local.bucket_name}"
    Region      = "${var.region}"
    environment = "${var.environment}"
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket" "media" {
  bucket = "${local.media_bucket}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.media_bucket_public_policy.json}"

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET"]
    allowed_headers = ["Authorization"]
    max_age_seconds = 3000
  }

  tags {
    name        = "${local.media_bucket}"
    Region      = "${var.region}"
    Environment = "${var.environment}"
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_iam_role" "this" {
  name               = "${local.identifier}-${var.region}-role"
  assume_role_policy = "${data.aws_iam_policy_document.bucket_role.json}"

  tags {
    Name        = "${local.identifier}-${var.region}-role"
    Environment = "${var.environment}"
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${local.identifier}-${var.region}-policy"
  role   = "${aws_iam_role.this.id}"
  policy = "${data.aws_iam_policy_document.bucket_policy.json}"
}

resource "aws_iam_user" "this" {
  count = "${var.create_user}"
  name  = "developer-portal-publish-user-${var.environment}"
}

resource "aws_iam_user_policy" "this" {
  count  = "${var.create_user}"
  name   = "developer-portal-publis-policy-${var.environment}"
  user   = "${element(aws_iam_user.this.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.bucket_policy.json}"
}

resource "aws_iam_access_key" "this" {
  count = "${var.create_user}"
  user  = "${element(aws_iam_user.this.*.name, count.index)}"
}

data "aws_iam_policy_document" "bucket_public_policy" {
  statement {
    sid    = "AllowListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }

  statement {
    sid    = "AllowIndexHTML"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "media_bucket_public_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${local.media_bucket}/*",
    ]
  }
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
      "arn:aws:s3:::${local.media_bucket}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
      "arn:aws:s3:::${local.media_bucket}/*",
    ]
  }

  statement {
    sid    = "AllowCDNInvalidate"
    effect = "Allow"

    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidation",
    ]

    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.distribution_id}",
    ]
  }
}

locals {
  bucket_name = "${var.bucket_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"

  # All other things reference this
  identifier   = "${var.bucket_name}-${var.environment}"
  media_bucket = "${var.bucket_name}-${var.environment}-media-${data.aws_caller_identity.current.account_id}"
  log_bucket   = "${var.bucket_name}-${var.environment}-logs-${data.aws_caller_identity.current.account_id}"
  attachments  = "devportal-media-${var.environment}"
}

resource "aws_s3_bucket" "attachments" {
  bucket = local.attachments
  acl    = "public-read"
  policy = data.aws_iam_policy_document.attachment_bucket_public_policy.json

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET"]
    allowed_headers = ["Authorization"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = local.attachments
    Region      = var.region
    Environment = var.environment
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket" "logging" {
  count  = var.enable_logging ? 1 : 0
  bucket = local.log_bucket
  acl    = "log-delivery-write"

  tags = {
    Name        = local.log_bucket
    Region      = var.region
    Environment = var.environment
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_iam_role" "this" {
  name               = "${local.identifier}-${var.region}-role"
  assume_role_policy = data.aws_iam_policy_document.bucket_role.json

  tags = {
    Name        = "${local.identifier}-${var.region}-role"
    Environment = var.environment
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${local.identifier}-${var.region}-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0
  name  = "developer-portal-publish-user-${var.environment}"
}

resource "aws_iam_user_policy" "this" {
  count  = var.create_user ? 1 : 0
  name   = "developer-portal-publish-policy-${var.environment}"
  user   = element(aws_iam_user.this.*.name, count.index)
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_iam_access_key" "this" {
  count = var.create_user ? 1 : 0
  user  = element(aws_iam_user.this.*.name, count.index)
}

data "aws_iam_policy_document" "attachment_bucket_public_policy" {
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
      "arn:aws:s3:::${local.attachments}/*",
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
      identifiers = [var.eks_worker_role_arn]
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
      "arn:aws:s3:::${local.attachments}",
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
      "arn:aws:s3:::${local.attachments}/*",
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

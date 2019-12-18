locals {
  bucket_name = "${var.bucket_name}-${var.environment}"
}

resource "aws_s3_bucket" "media" {
  bucket = "${local.bucket_name}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.public-read.json}"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET"]
    allowed_headers = ["Authorization"]
    max_age_seconds = 3000
  }

  tags {
    Name        = "${local.bucket_name}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
    Service     = "MDN"
    Purpose     = "MDN Media bucket"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket" "logging" {
  bucket = "${local.bucket_name}-logs"
  acl    = "log-delivery-write"

  lifecycle_rule {
    enabled = true

    transition {
      days          = "60"
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = "90"
      storage_class = "GLACIER"
    }

    expiration {
      days = "180"
    }
  }

  tags {
    Name        = "${local.bucket_name}-logs"
    Region      = "${var.region}"
    Service     = "MDN"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

data "aws_iam_policy_document" "public-read" {
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
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "bucket-policy" {
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
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "bucket-policy" {
  name   = "${local.bucket_name}-role-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.bucket-policy.json}"
}

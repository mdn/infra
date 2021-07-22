resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.bucket_policy.json

  logging {
    target_bucket = aws_s3_bucket.logging.id
    target_prefix = "logs/"
  }

  tags = {
    Name      = var.bucket_name
    Project   = "insights"
    Terraform = "true"
  }
}

resource "aws_s3_bucket" "logging" {
  bucket = "${var.bucket_name}-logs"
  acl    = "log-delivery-write"
}

data "aws_iam_policy_document" "bucket_policy" {
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
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}

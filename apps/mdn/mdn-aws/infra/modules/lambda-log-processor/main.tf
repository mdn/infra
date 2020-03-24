provider "aws" {
  region = var.region
}

locals {
  create_destination_bucket_bool = var.create_destination_bucket ? 1 : 0
  destination_bucket_name        = "${var.destination_bucket}-${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {
}

data "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket
}

data "aws_iam_policy_document" "role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "log-permission" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "bucket-permission" {
  statement {
    sid    = "ListAllBuckets"
    effect = "Allow"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "GetFromSourceBucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.source_bucket}/*",
      "arn:aws:s3:::${var.source_bucket}",
    ]
  }

  statement {
    sid    = "CopyToDestBucket"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.destination_bucket_name}",
      "arn:aws:s3:::${local.destination_bucket_name}/*",
    ]
  }
}

resource "aws_s3_bucket" "log-processor-bucket" {
  count  = local.create_destination_bucket_bool
  bucket = local.destination_bucket_name

  tags = {
    Name      = local.destination_bucket_name
    Region    = var.region
    Terraform = "true"
  }
}

resource "aws_iam_role" "log-processor-role" {
  name               = "log-processor-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

resource "aws_iam_role_policy" "log-processor-cloudwatch" {
  name = "log-processor-cloudwatch-policy-${var.region}"
  role = aws_iam_role.log-processor-role.id

  policy = data.aws_iam_policy_document.log-permission.json
}

resource "aws_iam_role_policy" "log-processor-bucket" {
  name = "log-processor-bucket-policy-${var.region}"
  role = aws_iam_role.log-processor-role.id

  policy = data.aws_iam_policy_document.bucket-permission.json
}

data "archive_file" "log-processor-archive" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "log-processor" {
  filename      = "${path.module}/lambda_function_payload.zip"
  function_name = "cdn-log-processor-${var.region}"
  role          = aws_iam_role.log-processor-role.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.log-processor-archive.output_base64sha256
  runtime          = "python3.6"

  environment {
    variables = {
      DEST_BUCKET = aws_s3_bucket.log-processor-bucket[0].id
      DEBUG       = var.lambda_debug
    }
  }

  tags = {
    Name      = "log-processor-${var.region}"
    Region    = var.region
    Terraform = "true"
  }
}

resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log-processor.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.source_bucket.arn
}

resource "aws_s3_bucket_notification" "log-notification" {
  bucket = data.aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.log-processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
}


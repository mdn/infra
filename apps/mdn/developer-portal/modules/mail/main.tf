locals {
  iam_user   = "${var.service_name}-${var.environment}-${var.region}-ses"
  iam_policy = "${var.service_name}-${var.environment}-${var.region}-ses-policy"
}

resource "aws_iam_user" "email" {
  name = local.iam_user

  tags = {
    Name      = local.iam_user
    Service   = var.service_name
    Region    = var.region
    Terraform = "True"
  }
}

resource "aws_iam_access_key" "email" {
  user = aws_iam_user.email.name
}

data "aws_iam_policy_document" "email" {
  statement {
    effect = "Allow"

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "email" {
  name   = local.iam_policy
  user   = aws_iam_user.email.name
  policy = data.aws_iam_policy_document.email.json
}


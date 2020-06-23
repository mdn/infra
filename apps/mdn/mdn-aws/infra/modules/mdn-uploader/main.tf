locals {
  iam_user    = "${var.name}-${var.environment}-user"
  role_name   = "${var.name}-${var.environment}-role"
  create_user = var.create_user ? 1 : 0
}

resource "aws_iam_user" "this" {
  count = local.create_user
  name  = local.iam_user

  tags = {
    Name        = local.iam_user
    Environment = var.environment
    Service     = "MDN"
    Terraform   = "true"
  }
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = local.create_user * length(var.iam_policies)
  user       = aws_iam_user.this[0].name
  policy_arn = element(var.iam_policies, count.index)
}

resource "aws_iam_access_key" "this" {
  count = local.create_user
  user  = element(aws_iam_user.this.*.name, count.index)
}


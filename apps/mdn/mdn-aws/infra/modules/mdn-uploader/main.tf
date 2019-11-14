locals {
  iam_user  = "${var.name}-${var.environment}-user"
  role_name = "${var.name}-${var.environment}-role"
}

resource "aws_iam_role" "this" {
  name               = "${local.role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"

  tags {
    Name        = "${local.role_name}"
    Environment = "${var.environment}"
    Service     = "MDN"
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = "${length(var.iam_policies)}"
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${var.iam_policies[count.index]}"
}

data "aws_iam_policy_document" "assume_role" {
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

resource "aws_iam_user" "this" {
  count = "${var.create_user}"
  name  = "${local.iam_user}"

  tag {
    Name        = "${local.iam_user}"
    Environment = "${var.environment}"
    Service     = "MDN"
    Terraform   = "true"
  }
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = "${var.create_user * length(var.iam_policies)}"
  user       = "${aws_iam_user.this.name}"
  policy_arn = "${element(var.iam_policies, count.index)}"
}

resource "aws_iam_access_key" "this" {
  count = "${var.create_user}"
  user  = "${element(aws_iam_user.this.*.name, count.index)}"
}

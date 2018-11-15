# NOTE: Not ideal way of doing this

provider "aws" {
  region = "us-west-2"
}

data "aws_network_acls" "us-west-2-nacl" {
  vpc_id   = "${var.us-west-2-vpc-id}"

  tags {
    Service = "MDN"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "worf" {
  name = "${var.security-user}"
}

resource "aws_iam_access_key" "worf-keys" {
  user = "${aws_iam_user.worf.name}"
}

data "template_file" "worf_policy" {
  template = "${file("${path.module}/worf-policy.json.tmpl")}"

  # Not ideal, data provider returns a list
  vars {
    account_id           = "${data.aws_caller_identity.current.account_id}"
    us-west-2-nacl-id    = "${element(concat(data.aws_network_acls.us-west-2-nacl.ids, list("")), 0)}"
  }
}

resource "aws_iam_user_policy" "worf-policy" {
  name = "worf-policy"
  user = "${aws_iam_user.worf.name}"

  policy = "${data.template_file.worf_policy.rendered}"
}

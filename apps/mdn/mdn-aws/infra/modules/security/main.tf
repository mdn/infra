# NOTE: Not ideal way of doing this

provider "aws" {
  alias  = "lookup-us-west-2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "lookup-eu-central-1"
  region = "eu-central-1"
}

data "aws_network_acls" "us-west-2-nacl" {
  provider = "aws.lookup-us-west-2"
  vpc_id   = "${var.us-west-2-vpc-id}"

  tags {
    Service = "MDN"
  }
}

data "aws_network_acls" "eu-central-1-nacl" {
  provider = "aws.lookup-eu-central-1"
  vpc_id   = "${var.eu-central-1-vpc-id}"

  tags {
    Service = "MDN"
  }
}

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
    us-west-2-nacl-id    = "${element(concat(data.aws_network_acls.us-west-2-nacl.ids, list("")), 0)}"
    eu-central-1-nacl-id = "${element(concat(data.aws_network_acls.eu-central-1-nacl.ids, list("")), 0)}"
  }
}

resource "aws_iam_user_policy" "worf-policy" {
  name = "worf-policy"
  user = "${aws_iam_user.worf.name}"

  policy = "${data.template_file.worf_policy.rendered}"
}

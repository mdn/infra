locals {
  default_tags = {
    Region    = "${var.region}"
    Terraform = "true"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_vpc_dhcp_options" "this" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = "${merge(local.default_tags, var.tags)}"
}

resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = "${aws_vpc.this.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.this.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.this.id}"

  tags = "${merge(local.default_tags, var.tags)}"
}

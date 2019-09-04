terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/dns"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "${var.region}"
}

resource aws_route53_delegation_set "delegation-set" {
  lifecycle {
    create_before_destroy = true
  }

  reference_name = "${var.reference_name}"
}

resource aws_route53_zone "master-zone" {
  name = "${var.domain_name}"

  delegation_set_id = "${aws_route53_delegation_set.delegation-set.id}"

  tags {
    Name    = "${var.domain_name}"
    Purpose = "MDN DNS master zone"
  }
}

resource aws_route53_zone "mdn-dev" {
  name = "mdn.dev"

  delegation_set_id = "${aws_route53_delegation_set.delegation-set.id}"

  tags {
    Name    = "mdn.dev"
    Purpose = "mdn.dev master zone"
  }
}

# Hosted zone for mozit.cloud domains
# everything not mozit.cloud doesn't go here
module "us-west-2" {
  source      = "./hosted_zone"
  zone_name   = "us-west-2"
  domain_name = "${var.domain_name}"
  zone_id     = "${aws_route53_zone.master-zone.id}"
}

module "eu-central-1" {
  source      = "./hosted_zone"
  zone_name   = "eu-central-1"
  domain_name = "${var.domain_name}"
  zone_id     = "${aws_route53_zone.master-zone.id}"
}

module "us-west-2a" {
  source      = "./hosted_zone"
  zone_name   = "us-west-2a"
  domain_name = "${var.domain_name}"
  zone_id     = "${aws_route53_zone.master-zone.id}"
}

module "stage" {
  source      = "./hosted_zone"
  zone_name   = "stage"
  domain_name = "${var.domain_name}"
  zone_id     = "${aws_route53_zone.master-zone.id}"
}

provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  alias  = "aws-acm"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/insights"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/dns"
    region = "us-west-2"
  }
}

data "aws_acm_certificate" "insights-stage" {
  provider = "aws.aws-acm"
  domain   = "insights.developer.allizom.org"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "insights-prod" {
  provider = "aws.aws-acm"
  domain   = "insights.developer.mozilla.org"
  statuses = ["ISSUED"]
}

module "insights-dns-stage" {
  source            = "./modules/dns"
  domain-zone-id    = "${data.terraform_remote_state.dns.master-zone}"
  domain-name       = "insights-stage.mdn.mozit.cloud"
  domain-name-alias = "${module.insights-stage.cloudfront_domain}"
  alias-zone-id     = "${module.insights-stage.cloudfront_hosted_zone_id}"
}

module "insights-stage" {
  source              = "./modules/cdn"
  environment         = "stage"
  cloudfront_aliases  = ["insights.developer.allizom.org", "insights-stage.mdn.mozit.cloud"]
  acm_certificate_arn = "${data.aws_acm_certificate.insights-stage.arn}"
}

module "insights-dns-prod" {
  source            = "./modules/dns"
  domain-zone-id    = "${data.terraform_remote_state.dns.master-zone}"
  domain-name       = "insights-prod.mdn.mozit.cloud"
  domain-name-alias = "${module.insights-stage.cloudfront_domain}"
  alias-zone-id     = "${module.insights-stage.cloudfront_hosted_zone_id}"
}

module "insights-prod" {
  source              = "./modules/cdn"
  environment         = "prod"
  cloudfront_aliases  = ["insights.developer.mozilla.org", "insights-prod.mdn.mozit.cloud"]
  acm_certificate_arn = "${data.aws_acm_certificate.insights-prod.arn}"
}

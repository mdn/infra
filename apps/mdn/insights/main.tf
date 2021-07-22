provider "aws" {
  region = var.region
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

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/dns"
    region = "us-west-2"
  }
}

data "aws_acm_certificate" "insights-prod" {
  provider = aws.aws-acm
  domain   = "insights.developer.mozilla.org"
  statuses = ["ISSUED"]
}

module "bucket" {
  source = "./modules/bucket"
}

module "insights-dns-prod" {
  source            = "./modules/dns"
  domain-zone-id    = data.terraform_remote_state.dns.outputs.master-zone
  domain-name       = "insights-prod"
  domain-name-alias = module.insights-prod.cloudfront_domain
}

module "insights-prod" {
  source              = "./modules/cdn"
  environment         = "prod"
  cloudfront_aliases  = ["insights.developer.mozilla.org", "insights-prod.mdn.mozit.cloud"]
  acm_certificate_arn = data.aws_acm_certificate.insights-prod.arn
}

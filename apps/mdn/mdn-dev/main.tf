provider "aws" {
  version = "~> 2"
  region  = var.region
}

provider "aws" {
  alias  = "aws-acm"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/mdn-dev"
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

data "aws_acm_certificate" "mdn-dev" {
  provider = aws.aws-acm
  domain   = "mdn.dev"
  statuses = ["ISSUED"]
}

module "dns-mozit" {
  source            = "./modules/dns"
  domain-zone-id    = data.terraform_remote_state.dns.outputs.master-zone
  domain-name       = "mdn-dev.mdn.mozit.cloud"
  domain-name-alias = module.mdn-dev.cloudfront_domain
  alias-zone-id     = module.mdn-dev.cloudfront_hosted_zone_id
}

module "dns-mdn-dev" {
  source            = "./modules/dns"
  domain-zone-id    = data.terraform_remote_state.dns.outputs.mdn-dev-zone
  domain-name       = "mdn.dev"
  domain-name-alias = module.mdn-dev.cloudfront_domain
  alias-zone-id     = module.mdn-dev.cloudfront_hosted_zone_id
}

module "mdn-dev" {
  source              = "./modules/cdn"
  cloudfront_aliases  = ["mdn.dev", "mdn-dev.mdn.mozit.cloud"]
  acm_certificate_arn = data.aws_acm_certificate.mdn-dev.arn
}


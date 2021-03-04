# Put acm certs thats needed here, just makes the main.tf less insane

# ACM certs for cloudfront needs to be created in us-east-1
# as documented here: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html
provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

module "acm_ci" {
  source      = "./modules/acm"
  domain_name = "ci.us-west-2.mdn.mozit.cloud"
  zone_id     = data.terraform_remote_state.dns.outputs.us-west-2-zone-id
}

data "aws_acm_certificate" "attachment-cdn-cert" {
  provider = aws.acm
  domain   = "mdn.mozillademos.org"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "stage-media-cdn-cert" {
  provider = aws.acm
  domain   = "media.stage.mdn.mozit.cloud"
}

data "aws_acm_certificate" "prod-media-cdn-cert" {
  provider = aws.acm
  domain   = "media.prod.mdn.mozit.cloud"
}


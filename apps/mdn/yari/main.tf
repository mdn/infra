

module "sns-pagerduty" {
  providers = {
    aws = aws.us-east-1
  }

  source     = "github.com/mozilla-it/terraform-modules//aws/cloudwatch-sns?ref=master"
  topic_name = "cloudwatch-to-pd"
  region     = "us-east-1"
}

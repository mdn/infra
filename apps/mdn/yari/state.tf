terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/yari/tfstate.tf"
    region = "us-west-2"
  }
}

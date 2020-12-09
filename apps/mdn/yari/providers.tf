
provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = var.cdn_region
}

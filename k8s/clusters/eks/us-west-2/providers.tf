provider "aws" {
  version = ">= 2.6.0"
  region  = "${var.region}"
}

provider "local" {
  version = "~> 1.2"
}

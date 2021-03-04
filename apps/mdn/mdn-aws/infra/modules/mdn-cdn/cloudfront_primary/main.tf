locals {
  log_bucket = "${var.distribution_name}-logs"
}

resource "random_id" "rand-var" {
  keepers = {
    bucket_name = local.log_bucket
  }

  byte_length = 8
}

resource "aws_s3_bucket" "logging" {
  bucket = "${local.log_bucket}-${random_id.rand-var.hex}"
  acl    = "log-delivery-write"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = var.standard_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }
  }

  tags = {
    Name        = "${local.log_bucket}-${random_id.rand-var.hex}"
    Environment = var.environment
    Service     = "MDN"
    Purpose     = "Cloudfront logging bucket"
  }
}


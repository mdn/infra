resource "random_id" "rand-var" {
  keepers = {
    backup_bucket = "${var.backup-bucket}"
  }

  byte_length = 8
}

locals {
  backup-bucket      = "${var.backup-bucket}-${random_id.rand-var.hex}"
  backup-bucket-logs = "${var.backup-bucket}-logs-${random_id.rand-var.hex}"
}

resource "aws_s3_bucket" "backup-bucket-logging" {
  bucket = "${local.backup-bucket-logs}"
  acl    = "log-delivery-write"

  tags {
    Name    = "${local.backup-bucket-logs}"
    Region  = "${var.region}"
    Service = "MDN"
    Purpose = "RDS Backup bucket logs"
  }
}

resource "aws_s3_bucket" "backup-bucket" {
  bucket = "${local.backup-bucket}"
  region = "${var.region}"
  acl    = "${var.bucket-acl}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 60
    }
  }

  logging {
    target_bucket = "${aws_s3_bucket.backup-bucket-logging.id}"
    target_prefix = "logs/"
  }

  tags {
    Name    = "${local.backup-bucket}"
    Region  = "${var.region}"
    Service = "MDN"
    Purpose = "RDS backup bucket"
  }
}

resource "aws_iam_user" "backup-user" {
  name = "${var.backup-user}"
}

resource "aws_iam_access_key" "backup-user-key" {
  user = "${aws_iam_user.backup-user.name}"
}

resource "aws_iam_user_policy" "backup-user-policy" {
  name = "rds-backup-user"
  user = "${aws_iam_user.backup-user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${local.backup-bucket}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.backup-bucket}/*"
            ]
        }
    ]
}
EOF
}

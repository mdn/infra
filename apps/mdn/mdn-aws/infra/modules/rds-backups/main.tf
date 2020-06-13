resource "random_id" "rand-var" {
  keepers = {
    backup_bucket = var.backup-bucket
  }

  byte_length = 8
}

locals {
  backup-bucket      = "${var.backup-bucket}-${random_id.rand-var.hex}"
  backup-bucket-logs = "${var.backup-bucket}-logs-${random_id.rand-var.hex}"
}

resource "aws_s3_bucket" "backup-bucket-logging" {
  bucket = local.backup-bucket-logs
  acl    = "log-delivery-write"

  tags = {
    Name    = local.backup-bucket-logs
    Region  = var.region
    Service = "MDN"
    Purpose = "RDS Backup bucket logs"
  }
}

resource "aws_s3_bucket" "backup-bucket" {
  bucket = local.backup-bucket
  region = var.region
  acl    = var.bucket-acl

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
    target_bucket = aws_s3_bucket.backup-bucket-logging.id
    target_prefix = "logs/"
  }

  tags = {
    Name    = local.backup-bucket
    Region  = var.region
    Service = "MDN"
    Purpose = "RDS backup bucket"
  }
}

provider "aws" {
  region = "eu-central-1"
  alias  = "eks"
}

data "aws_eks_cluster" "this" {
  provider = aws.eks
  name     = var.eks_cluster_id
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.10.0"
  create_role                   = true
  role_name                     = "mdn-rds-backups"
  provider_url                  = replace(data.aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.rds_backup_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.rds_backup_namespace}:${var.rds_backup_sa}"]
}

resource "aws_iam_policy" "rds_backup_policy" {
  name_prefix = "mdn-rds-backup-policy-"
  description = "EKS mdn-rds-backup policy for cluster ${var.eks_cluster_id}"
  policy      = data.aws_iam_policy_document.rds_backup_policy.json
}

data "aws_iam_policy_document" "rds_backup_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${local.backup-bucket}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${local.backup-bucket}/*"
    ]
  }
}

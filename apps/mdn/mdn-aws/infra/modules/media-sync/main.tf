module "iam_assumable_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.10.0"
  create_role                   = true
  role_name                     = "media-sync-role"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.media-sync.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"]
}

resource "aws_iam_policy" "media-sync" {
  name_prefix = "media-sync"
  description = "Allow the 2 media / attachment buckets to sync"
  policy      = data.aws_iam_policy_document.media-sync.json
}

data "aws_iam_policy_document" "media-sync" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.stage_bucket}/*",
      "arn:aws:s3:::${var.prod_bucket}/*"
    ]
  }
}

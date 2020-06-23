output "bucket_id" {
  value = element(concat(aws_s3_bucket.this.*.id, [""]), 0)
}

output "bucket_iam_role_name" {
  value = module.iam_assumable_role_admin.this_iam_role_name
}

output "bucket_iam_role_arn" {
  value = module.iam_assumable_role_admin.this_iam_role_arn
}

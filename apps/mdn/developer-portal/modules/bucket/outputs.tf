output "bucket_id" {
  value = "${element(concat(aws_s3_bucket.this.*.id, list("")),0)}"
}

output "bucket_website_endpoint" {
  value = "${element(concat(aws_s3_bucket.this.*.website_endpoint, list("")),0)}"
}

output "bucket_hosted_zone_id" {
  value = "${element(concat(aws_s3_bucket.this.*.hosted_zone_id, list("")),0)}"
}

output "bucket_iam_role_name" {
  value = "${element(concat(aws_iam_role.this.*.name, list("")),0)}"
}

output "bucket_iam_role_arn" {
  value = "${element(concat(aws_iam_role.this.*.arn, list("")),0)}"
}

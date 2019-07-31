output "efs_id" {
  value = "${aws_efs_file_system.this.id}"
}

output "efs_dns" {
  value = "${element(concat(aws_efs_file_system.this.*.id, list("")),0)}.${var.region}.amazonaws.com"
}

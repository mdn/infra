output "efs_dns" {
  value = "${element(concat(aws_efs_file_system.mdn-shared-efs.*.id, [""]), 0)}.${var.region}.amazonaws.com"
}


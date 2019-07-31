provider "aws" {
  region = "${var.region}"
}

resource "aws_efs_file_system" "this" {
  performance_mode = "generalPurpose"

  tags {
    Name        = "developer-portal-${var.environment}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_efs_mount_target" "this" {
  count           = "${length(var.subnets)}"
  file_system_id  = "${aws_efs_file_system.this.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${var.nodes_security_group}"]
}

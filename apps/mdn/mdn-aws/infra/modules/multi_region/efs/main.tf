provider "aws" {
  region = "${var.region}"
}

resource "aws_efs_file_system" "mdn-shared-efs" {
  count            = "${var.enabled}"
  performance_mode = "${var.performance_mode}"

  tags {
    Name        = "mdn-shared-${var.efs_name}"
    Stack       = "MDN-${var.efs_name}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}

resource "aws_efs_mount_target" "mdn-shared-mt" {
  count = "${var.enabled * length(split(",", var.subnets))}"

  # split the subnet variable into a list, then take the length of the list
  count = "${length(split(",", var.subnets))}"

  # use the EFS filesystem we created above
  file_system_id = "${aws_efs_file_system.mdn-shared-efs.id}"

  # split the subnet variable into a list, then get the count.index subnet id
  subnet_id       = "${element(split(",", var.subnets), count.index)}"
  security_groups = ["${var.nodes_security_group}"]
}

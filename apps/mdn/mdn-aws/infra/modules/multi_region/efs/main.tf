provider "aws" {
  region = var.region
}

locals {
  enabled = var.enabled ? 1 : 0
}

resource "aws_efs_file_system" "mdn-shared-efs" {
  count            = local.enabled
  performance_mode = var.performance_mode

  tags = {
    Name        = "mdn-shared-${var.efs_name}"
    Stack       = "MDN-${var.efs_name}"
    Environment = var.environment
    Region      = var.region
    Terraform   = "true"
  }
}

resource "aws_efs_mount_target" "mdn-shared-mt" {
  count = local.enabled * length(split(",", var.subnets))

  # use the EFS filesystem we created above
  file_system_id = aws_efs_file_system.mdn-shared-efs[0].id

  # split the subnet variable into a list, then get the count.index subnet id
  subnet_id       = element(split(",", var.subnets), count.index)
  security_groups = var.nodes_security_group
}


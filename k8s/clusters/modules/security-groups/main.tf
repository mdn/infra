data "aws_vpc" "this" {
  id = var.vpc_id
}

resource "aws_security_group" "ssh" {
  name_prefix = "eks-allow-ssh-${var.region}-"
  description = "Allow inbound SSH to managed node"
  vpc_id      = data.aws_vpc.this.id

  tags = {
    Name      = "eks-allow-ssh-${var.region}-sg"
    Terraform = "true"
    Region    = var.region
  }
}

resource "aws_security_group_rule" "eks-ingress-ssh-custom" {
  count             = length(var.ip_whitelist) > 0 ? 1 : 0
  cidr_blocks       = var.ip_whitelist
  description       = "Allow VPC Cidr block to ssh in"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "eks-ingress-ssh-vpc" {
  cidr_blocks       = [data.aws_vpc.this.cidr_block]
  description       = "Allow VPC Cidr block to ssh in"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "eks-egress-all" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow Outbound all"
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ssh.id
}

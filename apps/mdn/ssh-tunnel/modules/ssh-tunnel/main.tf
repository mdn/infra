
locals {
  prefix = "ssh-tunnel"

  default_tags = {
    Environment = "prod"
    Service     = "ssh-tunnel"
    Region      = var.region
    Terraform   = true
  }
}

resource "aws_eip" "ssh-tunnel" {
  vpc = true

  tags = merge(
    {
      Name = "${local.prefix}-eip"
    },
    local.default_tags
  )
}

resource "aws_security_group" "ssh-tunnel" {
  name        = "${local.prefix}-sg"
  description = "Allow inbound traffic to ${local.prefix}"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${local.prefix}-sg"
    },
    local.default_tags
  )
}

resource "aws_security_group_rule" "allow_ingress_ssh" {
  security_group_id = aws_security_group.ssh-tunnel.id
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"

  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "allow_egress_all" {
  security_group_id = aws_security_group.ssh-tunnel.id
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_iam_instance_profile" "ssh-tunnel" {
  name = "${local.prefix}-${var.region}-instance-profile"
  role = aws_iam_role.ssh-tunnel.name
}

resource "aws_iam_role" "ssh-tunnel" {
  name               = "${local.prefix}-${var.region}-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ssh-tunnel.json
}

resource "aws_iam_role_policy" "ssh-tunnel" {
  name   = "eip-allow-${var.region}"
  role   = aws_iam_role.ssh-tunnel.id
  policy = data.aws_iam_policy_document.associate-eip.json
}

resource "aws_key_pair" "ssh-tunnel" {
  lifecycle {
    create_before_destroy = true
  }

  key_name   = "ssh-tunnel"
  public_key = var.ssh_pubkey
}


module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name    = local.prefix
  lc_name = "${local.prefix}-lc"

  image_id                     = data.aws_ami.ubuntu_linux.id
  instance_type                = var.instance_type
  security_groups              = [aws_security_group.ssh-tunnel.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true
  key_name                     = aws_key_pair.ssh-tunnel.key_name

  root_block_device = [
    {
      volume_size           = "10"
      volume_type           = "gp2"
      delete_on_termination = true
    }
  ]

  tags = flatten([
    for key in keys(local.default_tags) : {
      key                 = key
      value               = local.default_tags[key]
      propagate_at_launch = true
    }
  ])

  asg_name             = local.prefix
  vpc_zone_identifier  = data.aws_subnet_ids.public_subnets.ids
  health_check_type    = "EC2"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  spot_price           = var.spot_price
  iam_instance_profile = aws_iam_instance_profile.ssh-tunnel.name
  user_data            = data.template_cloudinit_config.config.rendered
}

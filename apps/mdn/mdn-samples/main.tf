provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/mdn-samples"
    region = "us-west-2"
  }
}

resource "aws_key_pair" "mdn-samples" {
  lifecycle {
    create_before_destroy = true
  }

  key_name   = "mdn-samples"
  public_key = "${var.ssh_pubkey}"
}

resource "aws_eip" "mdn-samples" {
  vpc = true
}

resource "aws_security_group" "mdn-samples" {
  name        = "mdn-samples-sg"
  description = "Allow inbound traffic to mdn-samples"

  vpc_id = "${data.terraform_remote_state.kubernetes-us-west-2.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "mdn-samples-sg"
    Region    = "${var.region}"
    Service   = "mdn-samples"
    Terraform = "true"
  }
}

data "template_file" "user-data" {
  template = "${file("${path.module}/templates/user-data.sh")}"
}

data "template_file" "terraform-data" {
  template = "${file("${path.module}/templates/terraform-data.sh")}"

  vars = {
    eip_id = "${aws_eip.mdn-samples.id}"
    region = "${var.region}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "01-terraform-data.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.terraform-data.rendered}"
  }

  part {
    filename     = "02-user-data.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.user-data.rendered}"
  }
}

resource "aws_autoscaling_group" "mdn-samples" {
  vpc_zone_identifier = ["${data.aws_subnet_ids.subnet_id.ids}"]

  name = "mdn-samples - ${aws_launch_configuration.mdn-samples.name}"

  lifecycle {
    create_before_destroy = true
  }

  max_size                  = "1"
  min_size                  = "1"
  desired_capacity          = "1"
  health_check_grace_period = 1800

  # Less than ideal but the initial sync takes such a long time
  health_check_type    = "EC2"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.mdn-samples.name}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tag {
    key                 = "Name"
    value               = "mdn-samples.${var.region}.${var.domain}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Service"
    value               = "mdn-samples"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "mdn-samples" {
  name_prefix = "mdn-samples-"

  image_id = "${data.aws_ami.centos.id}"

  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.mdn-samples.key_name}"
  associate_public_ip_address = true

  #user_data     = "${data.template_file.user-data.rendered}"
  user_data            = "${data.template_cloudinit_config.config.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.mdn-samples.name}"

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    "${aws_security_group.mdn-samples.id}",
  ]

  enable_monitoring = false

  root_block_device = {
    volume_size           = "80"
    volume_type           = "gp2"
    delete_on_termination = false
  }
}

data "aws_iam_policy_document" "mdn-samples" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "associate-eip" {
  statement {
    sid       = "AllowEipAssociate"
    effect    = "Allow"
    actions   = ["ec2:AssociateAddress"]
    resources = ["*"]
  }
}

resource "aws_iam_instance_profile" "mdn-samples" {
  name = "mdn-samples-${var.region}"
  role = "${aws_iam_role.mdn-samples.name}"
}

resource "aws_iam_role" "mdn-samples" {
  name = "mdn-samples-${var.region}"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.mdn-samples.json}"
}

resource "aws_iam_role_policy" "mdn-samples" {
  name   = "eip-allow-${var.region}"
  role   = "${aws_iam_role.mdn-samples.id}"
  policy = "${data.aws_iam_policy_document.associate-eip.json}"
}

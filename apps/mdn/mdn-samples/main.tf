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

  vars = {
    eip_id = "${aws_eip.mdn-samples.id}"
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

  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.mdn-samples.key_name}"
  user_data     = "${data.template_file.user-data.rendered}"

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

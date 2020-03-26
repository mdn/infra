provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/ci"
    region = "us-west-2"
  }
}

resource "aws_key_pair" "mdn" {
  lifecycle {
    create_before_destroy = true
  }

  key_name   = "mdn"
  public_key = var.ssh_pubkey
}

resource "aws_eip" "ci-eip" {
  vpc = true

  tags = {
    Name      = "ci-eip"
    Service   = "MDN"
    Region    = var.region
    Terraform = "true"
  }
}

# Create a new load balancer
resource "aws_elb" "ci" {
  name    = "ci-elb-${var.project}"
  subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = data.aws_acm_certificate.ci.arn
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing = true

  security_groups = [
    aws_security_group.elb.id,
  ]

  tags = {
    Name   = "ci-elb"
    Region = var.region
  }
}

resource "aws_security_group" "elb" {
  name        = "ci-elb-sg"
  description = "Allow inbound traffic from ELB to CI"
  vpc_id      = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id

  tags = {
    Name      = "ci-elb-sg"
    Region    = var.region
    Service   = "MDN"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "http-mozilla-vpn-ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  cidr_blocks       = var.mozilla_vpn_whitelist
}

resource "aws_security_group_rule" "https-mozilla-vpn-ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.elb.id
  cidr_blocks       = var.mozilla_vpn_whitelist
}

resource "aws_security_group_rule" "elb_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.elb.id
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "ci" {
  name        = "ci-sg"
  description = "Allow inbound traffic to CI from ELB"

  vpc_id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id

  tags = {
    Name      = "ci-sg"
    Region    = var.region
    Service   = "MDN"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "ci_ingress_https" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ci.id
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "ci_ingress_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ci.id
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "ci_ingress_4443" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ci.id
  from_port                = "4443"
  to_port                  = "4443"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "ci_ingress_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.ci.id
  from_port         = "22"
  to_port           = "22"
  protocol          = "TCP"
  cidr_blocks       = var.ip_whitelist
}

resource "aws_security_group_rule" "ci_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.ci.id
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_autoscaling_group" "ci" {

  vpc_zone_identifier = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  # This is on purpose, when the LC changes, will force creation of a new ASG
  name = "ci-${var.project} - ${aws_launch_configuration.ci.name}"

  load_balancers = [
    aws_elb.ci.name,
  ]

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
  launch_configuration = aws_launch_configuration.ci.name

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
    value               = "ci.${var.region}.${var.domain}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = var.region
    propagate_at_launch = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")

  vars = {
    backup_dir         = var.backup_dir
    backup_bucket      = aws_s3_bucket.ci-backup-bucket.id
    nginx_htpasswd     = var.nginx_htpasswd
    jenkins_backup_dms = var.jenkins_backup_dms
    papertrail_host    = var.papertrail_host
    papertrail_port    = var.papertrail_port
    datadog_key        = var.datadog_key
    datadog_hostname   = var.datadog_hostname
    eip_id             = aws_eip.ci-eip.id
    region             = var.region
  }
}

resource "aws_launch_configuration" "ci" {
  name_prefix = "ci-${var.project}-"

  #image_id = "${data.aws_ami.ubuntu.id}"
  image_id = "ami-01e0cf6e025c036e4"

  instance_type               = var.instance_type
  key_name                    = aws_key_pair.mdn.key_name
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    aws_security_group.ci.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.ci.name

  enable_monitoring = false

  root_block_device {
    volume_size           = "250"
    volume_type           = "gp2"
    delete_on_termination = false
  }
}

resource "random_id" "rand-var" {
  keepers = {
    backup_bucket = var.backup_bucket
  }

  byte_length = 8
}

resource "aws_s3_bucket" "ci-backup-bucket" {
  bucket = "${var.backup_bucket}-${random_id.rand-var.hex}"
  acl    = "private"

  tags = {
    Name    = "${var.backup_bucket}-${random_id.rand-var.hex}"
    Region  = var.region
    Purpose = "Backup bucket for CI system"
  }
}

resource "aws_iam_instance_profile" "ci" {
  name = "ci-${var.project}-${var.region}"
  role = aws_iam_role.ci.name
}

resource "aws_iam_role" "ci" {
  name = "ci-${var.project}-${var.region}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ci-${var.project}-${var.region}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "ci-backup" {
  name = "ci-backups-${var.region}"
  role = aws_iam_role.ci.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListAllBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ListBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "${aws_s3_bucket.ci-backup-bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "${aws_s3_bucket.ci-backup-bucket.arn}",
        "${aws_s3_bucket.ci-backup-bucket.arn}/*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_policy" "mdn-interactive-permissive" {
  name        = "mdn-interactive-permissive"
  description = "Allow ci to push to interactive-example bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::mdninteractive-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::mdninteractive-*/*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "mdn-dev-s3" {
  name = "mdn-dev-s3-${var.region}"
  role = aws_iam_role.ci.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::mdn-dev-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::mdn-dev-*/*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "mdn-insights-s3" {
  name = "mdn-insights-s3-${var.region}"
  role = aws_iam_role.ci.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::insights-prod-*",
        "arn:aws:s3:::insights-stage-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::insights-prod-*",
        "arn:aws:s3:::insights-stage-*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "eks" {
  name = "eks"
  role = aws_iam_role.ci.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:ListClusters"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "associate-eip" {
  statement {
    sid       = "AllowEipAssociate"
    effect    = "Allow"
    actions   = ["ec2:AssociateAddress"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "associate-eip" {
  name   = "eip-attach-${var.region}"
  role   = aws_iam_role.ci.id
  policy = data.aws_iam_policy_document.associate-eip.json
}

resource "aws_iam_role_policy_attachment" "ci-role" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.mdn-interactive-permissive.arn
}


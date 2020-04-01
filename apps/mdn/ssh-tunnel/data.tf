data terraform_remote_state "vpc-us-west-2" {
  backend = "s3"

  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/vpc"
    region = "us-west-2"
  }
}

data terraform_remote_state "dns" {
  backend = "s3"
  config = {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/dns"
    region = "us-west-2"
  }
}

data "aws_ami" "ubuntu_linux" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-${var.ubuntu_version}-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_policy_document" "ssh-tunnel" {
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

locals {
  template = templatefile("${path.module}/templates/userdata.sh", {
    region       = var.region,
    eip_id       = aws_eip.ssh-tunnel.id,
    github_users = var.github_users
  })
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "01-user-data.sh"
    content_type = "text/x-shellscript"
    content      = local.template
  }
}

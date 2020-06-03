terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/us-west-2/eks"
    region = "us-west-2"
  }
}

module "mdn-jenkins-rbac" {
  source    = "../modules/jenkins-rbac"
  namespace = ["mdn-stage", "mdn-prod"]
  providers = {
    kubernetes = kubernetes.mdn
  }
}

resource "aws_security_group" "ssh" {
  name        = "eks-allow-ssh"
  description = "Allow inbound SSH"
  vpc_id      = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = [
      data.aws_vpc.us-west-2.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "eks-allow-ssh-sg"
    Terraform = "true"
    Region    = var.region
  }
}

module "ssh_sg" {
  source = "../modules/security-groups"
  region = var.region
  vpc_id = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
}

module "mdn" {
  source = "github.com/mozilla-it/terraform-modules//aws/eks?ref=master"

  region          = var.region
  vpc_id          = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  cluster_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name       = "mdn"
  cluster_version    = "1.16"
  node_groups        = local.mdn_node_groups
  map_roles          = local.map_roles
  velero_bucket_name = "velero-${module.mdn.cluster_id}-${var.region}-${data.aws_caller_identity.current.account_id}"
}

module "mdn-apps-a" {
  source = "../modules/eks"

  region      = var.region
  vpc_id      = data.terraform_remote_state.vpc-us-west-2.outputs.vpc_id
  eks_subnets = data.terraform_remote_state.vpc-us-west-2.outputs.public_subnets

  cluster_name    = "mdn-apps-a"
  cluster_version = "1.15"
  node_groups     = local.mdn_apps_node_groups
  map_roles       = local.map_roles
  map_users       = local.map_users
  tags            = local.cluster_tags
}


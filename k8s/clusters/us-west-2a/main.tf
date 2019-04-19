terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-us-west-2a"
    region = "us-west-2"
  }
}

provider aws {
  region = "${var.region}"
}

module "kubernetes" {
  source = "./out/terraform"
}

module "ark_bucket" {
  source       = "github.com/limed/tf-ark-backups?ref=master"
  region       = "${var.region}"
  bucket_name  = "cluster-backups"
  cluster_name = "oregon-a"
}

# Allow inbound ssh and http from specified IP's
resource "aws_security_group_rule" "inbound-ssh-to-master" {
  count             = "${length(module.kubernetes.master_security_group_ids)}"
  type              = "ingress"
  security_group_id = "${element(module.kubernetes.master_security_group_ids, count.index)}"
  from_port         = "22"
  to_port           = "22"
  protocol          = "TCP"
  cidr_blocks       = "${var.ip_whitelist}"
}

resource "aws_security_group_rule" "inbound-ssh-to-nodes" {
  count             = "${length(module.kubernetes.node_security_group_ids)}"
  type              = "ingress"
  security_group_id = "${element(module.kubernetes.node_security_group_ids, count.index)}"
  from_port         = "22"
  to_port           = "22"
  protocol          = "TCP"
  cidr_blocks       = "${var.ip_whitelist}"
}

resource "aws_security_group_rule" "inbound-https-to-master" {
  count             = "${length(module.kubernetes.master_security_group_ids)}"
  type              = "ingress"
  security_group_id = "${element(module.kubernetes.master_security_group_ids, count.index)}"
  from_port         = "443"
  to_port           = "443"
  protocol          = "TCP"
  cidr_blocks       = "${var.ip_whitelist}"
}

resource "aws_security_group_rule" "inbound-https-to-nodes" {
  count             = "${length(module.kubernetes.node_security_group_ids)}"
  type              = "ingress"
  security_group_id = "${element(module.kubernetes.node_security_group_ids, count.index)}"
  from_port         = "443"
  to_port           = "443"
  protocol          = "TCP"
  cidr_blocks       = "${var.ip_whitelist}"
}

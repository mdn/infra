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

# These are added here after terraform creates the kube cluster
# because we create a single AZ cluster, only subnet gets created.
# and that in turn makes things like RDS grumpy. So we import this after the fact
#
# terraform import aws_subnet.us-west-2b-k8s-us-west-2b-mdn-mozit-cloud <subnet id>

resource aws_subnet "us-west-2b-k8s-us-west-2a-mdn-mozit-cloud" {
  vpc_id            = "${module.kubernetes.vpc_id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "us-west-2b"

  tags = {
    KubernetesCluster                                      = "k8s.us-west-2a.mdn.mozit.cloud"
    Name                                                   = "us-west-2b.k8s.us-west-2a.mdn.mozit.cloud"
    SubnetType                                             = "Public"
    "kubernetes.io/cluster/k8s.us-west-2a.mdn.mozit.cloud" = "owned"
    "kubernetes.io/role/elb"                               = "1"
  }
}

resource aws_subnet "us-west-2c-k8s-us-west-2a-mdn-mozit-cloud" {
  vpc_id            = "${module.kubernetes.vpc_id}"
  cidr_block        = "172.20.96.0/19"
  availability_zone = "us-west-2c"

  tags = {
    KubernetesCluster                                      = "k8s.us-west-2a.mdn.mozit.cloud"
    Name                                                   = "us-west-2c.k8s.us-west-2a.mdn.mozit.cloud"
    SubnetType                                             = "Public"
    "kubernetes.io/cluster/k8s.us-west-2a.mdn.mozit.cloud" = "owned"
    "kubernetes.io/role/elb"                               = "1"
  }
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

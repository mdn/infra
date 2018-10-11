terraform {
  backend "s3" {
    bucket = "mdn-state-4e366a3ac64d1b4022c8b5e35efbd288"
    key    = "terraform/kubernetes-eu-central-1a"
    region = "us-west-2"
  }
}

provider aws {
  region = "${var.region}"
}

module "kubernetes" {
  source = "./out/terraform"
}

data aws_route_table "selected" {
  vpc_id = "${module.kubernetes.vpc_id}"

  filter = {
    name   = "tag:Name"
    values = ["k8s.${var.region}*"]
  }
}

# This is added after cluster creation
resource aws_subnet "eu-central-1b-k8s-eu-central-1a-mdn-mozit-cloud" {
  vpc_id            = "${module.kubernetes.vpc_id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "eu-central-1b"

  tags = {
    KubernetesCluster                                         = "k8s.eu-central-1a.mdn.mozit.cloud"
    Name                                                      = "eu-central-1b.k8s.eu-central-1a.mdn.mozit.cloud"
    SubnetType                                                = "Public"
    "kubernetes.io/cluster/k8s.eu-central-1a.mdn.mozit.cloud" = "owned"
    "kubernetes.io/role/elb"                                  = "1"
  }
}

resource "aws_route_table_association" "eu-central-1b-k8s-eu-central-1a-mdn-mozit-cloud" {
  subnet_id      = "${aws_subnet.eu-central-1b-k8s-eu-central-1a-mdn-mozit-cloud.id}"
  route_table_id = "${data.aws_route_table.selected.id}"
}

resource aws_subnet "eu-central-1c-k8s-eu-central-1a-mdn-mozit-cloud" {
  vpc_id            = "${module.kubernetes.vpc_id}"
  cidr_block        = "172.20.96.0/19"
  availability_zone = "eu-central-1c"

  tags = {
    KubernetesCluster                                         = "k8s.eu-central-1a.mdn.mozit.cloud"
    Name                                                      = "eu-central-1c.k8s.eu-central-1a.mdn.mozit.cloud"
    SubnetType                                                = "Public"
    "kubernetes.io/cluster/k8s.eu-central-1a.mdn.mozit.cloud" = "owned"
    "kubernetes.io/role/elb"                                  = "1"
  }
}

resource aws_route_table_association "eu-central-1c-k8s-eu-central-1a-mdn-mozit-cloud" {
  subnet_id      = "${aws_subnet.eu-central-1c-k8s-eu-central-1a-mdn-mozit-cloud.id}"
  route_table_id = "${data.aws_route_table.selected.id}"
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

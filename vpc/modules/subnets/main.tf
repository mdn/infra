locals {
  create_vpc = "${var.create_vpc ? 1 : 0}"
}

data "aws_availability_zone" "az" {
  count = "${length(var.azs)}"
  name  = "${var.azs[count.index]}"
}

### Private subnets ###
resource "aws_subnet" "private" {
  count = "${local.create_vpc * length(var.private_subnets_cidr)}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.private_subnets_cidr[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name                     = "${var.vpc_name}-private-${var.azs[count.index]}"
    Region                   = "${var.region}"
    SubnetType               = "Private"
    "kubernetes.io/role/elb" = "1"
    Terraform                = "true"
  }
}

# You get one thats it
resource "aws_eip" "nat" {
  count = "${local.create_vpc}"
  vpc   = true

  tags {
    Name      = "${var.vpc_name}-nat"
    Region    = "${var.region}"
    Terraform = "true"
  }
}

# Just dump it into the first subnet
resource "aws_nat_gateway" "nat_gw" {
  count         = "${local.create_vpc}"      # we just want one nat gw
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${var.public_subnets[0]}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["subnet_id"]
  }

  tags {
    Name      = "${var.vpc_name}-nat"
    Region    = "${var.region}"
    Terraform = "true"
  }
}

resource "aws_route_table" "private" {
  count  = "${local.create_vpc}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name                      = "${var.vpc_name}-rt-private"
    Region                    = "${var.region}"
    Terraform                 = "true"
    "kubernetes.io/kops/role" = "private"
  }
}

resource "aws_route_table_association" "private" {
  count = "${local.create_vpc * length(var.azs)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, 0)}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["subnet_id"]
  }
}

resource "aws_route" "private" {
  count                  = "${local.create_vpc}"
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["route_table_id", "nat_gateway_id"]
  }

  depends_on = ["aws_nat_gateway.nat_gw"]
}

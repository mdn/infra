locals {
  default_tags = {
    Region    = "${var.region}"
    Terraform = "true"
  }

  public_subnet_tags = {
    SubnetType                = "Public"
    "kubernetes.io/kops/role" = "public"
    "kubernetes.io/role/elb"  = "1"
  }

  private_subnet_tags = {
    SubnetType                        = "Private"
    "kubernetes.io/kops/role"         = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

### Public Subnets ####
resource "aws_subnet" "public" {
  count = "${length(var.public_subnet_cidrs)}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.public_subnet_cidrs[count.index]}"
  availability_zone       = "${var.azs[count.index]}"
  map_public_ip_on_launch = false

  tags = "${merge(map("Name", "${var.vpc_name}-public-${var.azs[count.index]}"), local.default_tags, local.public_subnet_tags, var.tags)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(map("Name", "${var.vpc_name}-rt-public"), local.default_tags, local.public_subnet_tags, var.tags)}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.igw_id}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["route_table_id", "nat_gateway_id"]
  }

  depends_on = ["aws_route_table.public"]
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["subnet_id"]
  }
}

### Private subnets ###
resource "aws_subnet" "private" {
  count = "${length(var.private_subnet_cidrs)}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.private_subnet_cidrs[count.index]}"
  availability_zone       = "${var.azs[count.index]}"
  map_public_ip_on_launch = false

  tags = "${merge(map("Name", "${var.vpc_name}-private-${var.azs[count.index]}"), local.default_tags, local.private_subnet_tags, var.tags)}"
}

# You get one thats it
resource "aws_eip" "nat" {
  vpc  = true
  tags = "${merge(map("Name", "${var.vpc_name}-nat"), local.default_tags)}"
}

# Just dump it into the first subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["subnet_id"]
  }

  tags = "${merge(map("Name", "${var.vpc_name}-nat"), local.default_tags)}"
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(map("Name", "${var.vpc_name}-rt-private"), local.default_tags, local.private_subnet_tags, var.tags)}"
}

resource "aws_route" "private" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["route_table_id", "nat_gateway_id"]
  }

  depends_on = ["aws_nat_gateway.nat_gw"]
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, 0)}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["subnet_id"]
  }
}

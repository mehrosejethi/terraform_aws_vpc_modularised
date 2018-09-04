resource "aws_subnet" "subnet" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${element(var.subnet_cidr_blocks_list,count.index)}"
  availability_zone = "${element(var.availability_zones_list, count.index)}"
  map_public_ip_on_launch = "${lookup(var.public_subnet_bool,var.subnet_type)}"

  count = "${length(var.subnet_cidr_blocks_list)}"
 
  tags {
    Name = "${element(var.subnet_name_list,count.index)}"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = "${var.vpc_id}"
  count = "${aws_subnet.subnet.count}"

  tags {
      Name = "${element(var.route_name_list,count.index)}"
  }
}

resource "aws_route" "igw_to_all_route" {
  route_table_id         = "${element(aws_route_table.route_table.*.id, count.index)}"
  gateway_id             = "${var.internet_gateway_id}"
  destination_cidr_block = "0.0.0.0/0"

  count = "${var.subnet_type == "public" || var.subnet_type == "nat" ? length(var.subnet_cidr_blocks_list) : 0}"
}

resource "aws_route" "peering_route" {
  route_table_id         = "${element(aws_route_table.route_table.*.id, count.index)}"
  vpc_peering_connection_id = "${var.vpc_peer_requester_id}"
  destination_cidr_block = "${var.vpc_peering_cidr_block}"

  count = "${var.subnet_type == "public" || var.subnet_type == "private" ? length(var.subnet_cidr_blocks_list) : 0}"
}

resource "aws_route" "ngw_to_all_route" {
  route_table_id         = "${element(aws_route_table.route_table.*.id, count.index)}"
  gateway_id             = "${element(var.nat_gateway_id_list,count.index)}"
  destination_cidr_block = "0.0.0.0/0"

  count = "${var.subnet_type == "private" ? length(var.subnet_cidr_blocks_list) : 0}"
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id = "${element(aws_subnet.subnet.*.id,count.index)}"
    route_table_id = "${element(aws_route_table.route_table.*.id,count.index)}"

    count = "${length(var.subnet_cidr_blocks_list)}"
}

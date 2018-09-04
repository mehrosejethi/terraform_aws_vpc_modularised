resource "aws_eip" "eip" {
  vpc = true
  
  count = "${length(var.availability_zones_list)}"

  tags {
    Name = "${element(var.eip_name_list, count.index)}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id     = "${element(var.public_subnet_ids, count.index)}"

  count = "${length(var.availability_zones_list)}"

  tags {
    Name = "${element(var.nat_name_list, count.index)}"
  }
}
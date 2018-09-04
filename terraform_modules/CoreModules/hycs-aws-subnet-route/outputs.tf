output "subnet_ids" {
  value = ["${aws_subnet.subnet.*.id}"]
}

output "route_table_ids" {
  value = ["${aws_route_table.route_table.*.id}"]
}

output "subnet_cidr_list" {
  value = ["${aws_subnet.subnet.*.cidr_block}"]
}


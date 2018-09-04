output "eip_ids" {
  value = ["${aws_eip.eip.*.id}"]
}

output "nat_gateway_ids" {
  value = ["${aws_nat_gateway.nat_gw.*.id}"]
}
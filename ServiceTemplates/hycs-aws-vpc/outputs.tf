/*
VPC
*/

output "aws_vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

/*
  Internet Gateway
*/

output "aws_internet_gateway_id" {
  value = "${aws_internet_gateway.vpc_ig.id}"
}

/*
  Subnets
*/

output "subnets_public_id" {
  value = "${module.subnet_public.subnet_ids}"
}

output "subnets_private_id" {
  value = "${module.subnet_private.subnet_ids}"
}

output "subnets_nat_id" {
  value = "${module.subnet_nat.subnet_ids}"
}

/*
  Route Table
*/

output "routes_public_id" {
  value = "${module.subnet_public.route_table_ids}"
}

output "routes_private_id" {
  value = "${module.subnet_private.route_table_ids}"
}

output "routes_nat_id" {
  value = "${module.subnet_nat.route_table_ids}"
}

/*
  Elastic IP's
*/

output "elastic_ip_ids" {
  value = "${module.nat_gateway.eip_ids}"
}

/*
  NAT Gateway
*/

output "nat_gateway_ids" {
  value = "${module.nat_gateway.nat_gateway_ids}"
}

/* 
  VPC Peering
*/

output "aws_vpc_peering_connection_id" {
  value = "${aws_vpc_peering_connection.peer_requester.id}"
}

output "aws_vpc_peering_connection_accepter_id" {
  value = "${aws_vpc_peering_connection_accepter.peer.id}"
}

/*
  S3 Endpoint
*/

output "aws_vpc_s3_endpoint_id" {
  value = "${aws_vpc_endpoint.s3.id}"
}

/*
  NACL
*/
output "public_nacl_id" {
  value = "${aws_default_network_acl.public_nacl.id}"
}

output "nat_nacl_id" {
  value = "${aws_network_acl.nat_nacl.id}"
}

output "private_nacl_id" {
  value = "${aws_network_acl.private_nacl.id}"
}

/*
  Security Group
*/

output "aws_default_security_group_id" {
  value = "${aws_default_security_group.vpc_sg_default.id}"
}

/*
  VPC Flow Log
*/

output "cloudwatch_flowlog_id" {
  value = "${module.flowlog_cloudwatch_log_group.cloudwatch_log_group_id}"
}

output "cloudwatch_flowlog_subscription_filter_id" {
  value = "${module.flowlog_cloudwatch_log_group.cloudwatch_subscription_filter_id}"
}

output "iam_flowlog_role_id" {
  value = "${module.flowlog_role_policy.role_id}"
}

output "iam_flowlog_policy_id" {
  value = "${module.flowlog_role_policy.policy_id}"
}

output "flow_log_id" {
  value = "${aws_flow_log.flow_log.id}"
}

/*
  EC2 Logging
*/


output "cloudwatch_syslog_id" {
  value = "${module.syslog_cloudwatch_log_group.cloudwatch_log_group_id}"
}

output "cloudwatch_syslog_subscription_filter_id" {
  value = "${module.syslog_cloudwatch_log_group.cloudwatch_subscription_filter_id}"
}

/* During account creation
output "iam_syslog_role_id" {
  value = "${module.syslog_log_role_policy.role_id}"
}

output "iam_syslog_policy_id" {
  value = "${module.syslog_log_role_policy.policy_id}"
}
*/

/* 
  AWS Config 
*/

output "iam_aws_config_role_id" {
  value = "${module.aws_config_role_policy.role_id}"
}

/* Policy Attaching part removed
output "iam_aws_config_policy_id" {
  value = "${module.aws_config_role_policy.role_id}"
}
*/

output "aws_config_configuration_recorder_id" {
  value = "${aws_config_configuration_recorder.aws_config_recorder.id}"
}

output "aws_config_delivery_channel_id" {
  value = "${aws_config_delivery_channel.aws_config_s3_delivery_channel.id}"
}



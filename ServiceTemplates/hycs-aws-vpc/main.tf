provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  assume_role {
    role_arn     = "arn:aws:iam::${var.assume_role_id}:role/OrganizationAccountAccessRole"
    
  }
}

provider "aws" {
  alias = "peer"
  
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  assume_role {
    role_arn     = "arn:aws:iam::${var.shared_service_account_id}:role/OrganizationAccountAccessRole"
  }
}

/*
  VPC
*/

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "${var.vpc_instance_tenancy}"
  
  tags {
    Name = "${var.vpc_name}"
  }
}

/*
  Internet Gateway
*/

resource "aws_internet_gateway" "vpc_ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.internet_gateway_name}"
  }
}

/*
  Public Subnet 
*/

module "subnet_public" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-subnet-route"

  subnet_type = "public"
  
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zones_list  = "${var.availability_zones_list}"
  subnet_cidr_blocks_list = "${var.subnet_public_cidr_list}"
  internet_gateway_id = "${aws_internet_gateway.vpc_ig.id}"
  vpc_peering_cidr_block = "${var.route_vpc_peering_cidr_block}"
  vpc_peer_requester_id = "${aws_vpc_peering_connection.peer_requester.id}"
  subnet_name_list = "${var.subnet_public_name_list}"
  route_name_list = "${var.route_public_name_list}"
}

/*
  NAT Subnet
*/

module "subnet_nat" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-subnet-route"

  subnet_type = "nat"
  
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zones_list  = "${var.availability_zones_list}"
  subnet_cidr_blocks_list = "${var.subnet_nat_cidr_list}"
  internet_gateway_id = "${aws_internet_gateway.vpc_ig.id}"
  subnet_name_list = "${var.subnet_nat_name_list}"
  route_name_list = "${var.route_nat_name_list}"
}


/*
  Private Subnet 
*/

module "subnet_private" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-subnet-route"

  subnet_type = "private"
  
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zones_list  = "${var.availability_zones_list}"
  subnet_cidr_blocks_list = "${var.subnet_private_cidr_list}"
  nat_gateway_id_list = "${module.nat_gateway.nat_gateway_ids}"
  vpc_peering_cidr_block = "${var.route_vpc_peering_cidr_block}"
  vpc_peer_requester_id = "${aws_vpc_peering_connection.peer_requester.id}"
  subnet_name_list = "${var.subnet_private_name_list}"
  route_name_list = "${var.route_private_name_list}"
}

/*
  NAT Gateway
*/

module "nat_gateway" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-nat-eip"

  availability_zones_list = "${var.availability_zones_list}"
  public_subnet_ids = "${module.subnet_public.subnet_ids}"
  eip_name_list = "${var.eip_name_list}"
  nat_name_list = "${var.nat_name_list}"
}

/* 
  VPC Peering
*/

data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

data "aws_vpc" "peer_vpc_data" {
  provider	= "aws.peer"
  id		= "${var.peer_vpcid}"
}

#Removing this block will delete the connection
resource "aws_vpc_peering_connection" "peer_requester" {
  vpc_id        = "${aws_vpc.vpc.id}"
  peer_vpc_id   = "${var.peer_vpcid}"
  peer_owner_id = "${data.aws_caller_identity.peer.account_id}"
  peer_region   = "${var.region}"
  
  tags {
    Name = "${var.vpc_peer_requester_name}"
  }
}

#On removing this block, there won"t be any change in the connection
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_requester.id}"
  auto_accept               = true
}

/*
  S3 Endpoint
*/

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.region}.s3"
  
  route_table_ids = ["${module.subnet_public.route_table_ids}"]
}

/*
  Public NACL
*/

resource "aws_default_network_acl" "public_nacl" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"
  
  subnet_ids = ["${module.subnet_public.subnet_ids}"]
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,0)}"
    from_port  = 1024
    to_port    = 65535
  }  
  
  ingress {
    protocol   = "tcp"
    rule_no    = 121
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,1)}"
    from_port  = 1024
    to_port    = 65535
  }  
  
  ingress {
    protocol   = -1
    rule_no    = 130
    action     = "allow"
    cidr_block = "${element(module.subnet_public.subnet_cidr_list,0)}"
    from_port  = 0
    to_port    = 0
  }
  
  ingress {
    protocol   = -1
    rule_no    = 131
    action     = "allow"
    cidr_block = "${element(module.subnet_public.subnet_cidr_list,1)}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,0)}"
    from_port  = 80
    to_port    = 80
  }
  
  egress {
    protocol   = "tcp"
    rule_no    = 501
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,1)}"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 510
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,0)}"
    from_port  = 443
    to_port    = 443
  }
  
  egress {
    protocol   = "tcp"
    rule_no    = 511
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,1)}"
    from_port  = 443
    to_port    = 443
  }

    egress {
    protocol   = "tcp"
    rule_no    = 520
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  
  tags {
    Name = "${var.public_nacl_name}"
  }
}

/*
  NAT NACL
*/

resource "aws_network_acl" "nat_nacl" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${module.subnet_nat.subnet_ids}"]
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,0)}"
    from_port  = 80
    to_port    = 80
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,1)}"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,0)}"
    from_port  = 443
    to_port    = 443
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 111
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,1)}"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }  

  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
	}

  egress {
    protocol   = "tcp"
    rule_no    = 510
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

    egress {
    protocol   = "tcp"
    rule_no    = 520
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


  tags {
    Name = "${var.nat_nacl_name}"
  }
}

/*
  Private NACL
*/

resource "aws_network_acl" "private_nacl" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = ["${module.subnet_private.subnet_ids}"]
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${element(module.subnet_public.subnet_cidr_list,0)}"
    from_port  = 80
    to_port    = 80
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "${element(module.subnet_public.subnet_cidr_list,1)}"
    from_port  = 80
    to_port    = 80
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "${data.aws_vpc.peer_vpc_data.cidr_block}"
    from_port  = 80
    to_port    = 80
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "${element(module.subnet_public.subnet_cidr_list,0)}"
    from_port  = 443
    to_port    = 443
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 121
    action     = "allow"
    cidr_block = "${element(module.subnet_public.subnet_cidr_list,1)}"
    from_port  = 443
    to_port    = 443
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "${data.aws_vpc.peer_vpc_data.cidr_block}"
    from_port  = 443
    to_port    = 443
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "${data.aws_vpc.peer_vpc_data.cidr_block}"
    from_port  = 22
    to_port    = 22
  }
  
  ingress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  
  ingress {
    protocol   = -1
    rule_no    = 160
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,0)}"
    from_port  = 0
    to_port    = 0
  }
  
  ingress {
    protocol   = -1
    rule_no    = 161
    action     = "allow"
    cidr_block = "${element(module.subnet_private.subnet_cidr_list,1)}"
    from_port  = 0
    to_port    = 0
  }
  
  ingress {
    protocol   = "icmp"
    rule_no    = 170
    action     = "allow"
    cidr_block = "${data.aws_vpc.peer_vpc_data.cidr_block}"
    from_port  = 0
    to_port    = 0
  }
  
  ingress {
    protocol   = "icmp"
    rule_no    = 180
    action     = "allow"
    cidr_block = "172.16.0.0/12"
    from_port  = 0
    to_port    = 0
  }
  
  egress {
    protocol   = -1
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "${var.private_nacl_name}"
  }
}

/*
  Security Group
*/

resource "aws_default_security_group" "vpc_sg_default" {
  vpc_id = "${aws_vpc.vpc.id}"
  
  tags {
    Name = "${var.security_group_vpc_name}"
  }
}

/*
  VPC Flow Log
*/

module "flowlog_role_policy" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-iam-role-policy"

  iam_policies_url = "${var.iam_policies_url}"
  iam_policy_directory = "IAM_System_Roles/HYCS_VPC_Flow_Logs.json"
  github_iam_token = "${var.github_iam_token}"
  iam_assume_role_policy_directory = "Trust_Relationships/IAM_SYSTEM_ROLES/VPC_Flow_Logs_TrustRelationship_Policy.json"
  iam_role_name = "${var.iam_flowlog_role_name}"
  iam_role_description = "VPCFlowLogs access"
  iam_policy_name = "${var.iam_flowlog_policy_name}"
  assume_role_account_id = "${var.assume_role_id}"
  stamp_letter = "${lookup(var.stamp_tag,var.stamp)}"
}

module "flowlog_cloudwatch_log_group" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-cloudwatch-log-group"

  cloudwatch_log_name                 = "${var.cloudwatch_flow_log_name}"
  cloudwatch_retention_days           = "${var.cw_flowlogs_retention_days}"
  cloudwatch_subscription_filter_name = "${var.cloudwatch_subscription_filter_name}"
  cloudwatch_filter_pattern           = "${var.cloudwatch_filter_pattern}"
  cloudwatch_filter_destination_arn   = "arn:aws:logs:${var.region}:${var.aws_security_admin_id}:destination:PA-CWD-${lookup(var.stamp_tag,var.stamp)}-${lookup(var.region_tag,var.region)}-S-FLGDST-001"
}

resource "aws_flow_log" "flow_log" {
  log_group_name = "${module.flowlog_cloudwatch_log_group.cloudwatch_log_group_name}"
  iam_role_arn   = "${module.flowlog_role_policy.role_arn}"
  vpc_id         = "${aws_vpc.vpc.id}"
  traffic_type   = "ALL"
}

/*
  EC2 Logging
*/

module "syslog_cloudwatch_log_group" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-cloudwatch-log-group"

  cloudwatch_log_name                 = "${var.cw_syslog_group}"
  cloudwatch_retention_days           = "${var.cw_syslogs_retention_days}"
  cloudwatch_subscription_filter_name = "${var.cloudwatch_subscription_filter_name}"
  cloudwatch_filter_pattern           = "${var.cloudwatch_filter_pattern}"
  cloudwatch_filter_destination_arn   = "arn:aws:logs:${var.region}:${var.aws_security_admin_id}:destination:PA-CWD-${lookup(var.stamp_tag,var.stamp)}-${lookup(var.region_tag,var.region)}-S-SYSLDST-001"
}

/* During account creation

module "syslog_log_role_policy" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-iam-role-policy"

  iam_policies_url = "${var.iam_policies_url}"
  iam_policy_directory = "IAM_System_Roles/HYCS_EC2_System_Role.json"
  github_iam_token = "${var.github_iam_token}"
  iam_assume_role_policy_directory = "Trust_Relationships/IAM_SYSTEM_ROLES/Ec2_System_Role_TrustPolicy.json"
  iam_role_name = "${var.iam_syslog_role_name}"
  iam_role_description = "EC2 access"
  iam_policy_name = "${var.iam_syslog_policy_name}"  
}

*/

/* 
  AWS Config 
*/

module "aws_config_role_policy" {
  source = "git::https://github.pwc.com/mehrose-jethi/terraform_modules.git//CoreModules/hycs-aws-iam-role-policy"

  iam_policies_url = "${var.iam_policies_url}"
  github_iam_token = "${var.github_iam_token}"
  iam_assume_role_policy_directory = "Trust_Relationships/IAM_SYSTEM_ROLES/AWSConfig_TrustPolicy.json"
  iam_role_name = "${var.iam_aws_config_role_name}"
  iam_role_description = "AWSConfig access"
  attach_custom_policy = false
}

resource "aws_config_configuration_recorder" "aws_config_recorder" {
  name     = "${var.aws_config_recorder_name}"
  role_arn = "${module.aws_config_role_policy.role_arn}"
  
  recording_group = {
    all_supported = "${var.all_config_supported_bool}"
  }
}

resource "aws_config_delivery_channel" "aws_config_s3_delivery_channel" {
  name           = "${var.aws_config_s3_delivery_channel_name}"
  s3_bucket_name = "${lookup(var.config_s3_bucket, var.stamp)}"
  sns_topic_arn  = "${lookup(var.sns_config_topic_arn, var.region)}"
  s3_key_prefix  = "${var.config_s3_prefix}"
  
  depends_on     = ["aws_config_configuration_recorder.aws_config_recorder"]
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = "${aws_config_configuration_recorder.aws_config_recorder.name}"
  is_enabled = "${var.is_config_enabled_bool}"
  
  depends_on = ["aws_config_delivery_channel.aws_config_s3_delivery_channel"]
}
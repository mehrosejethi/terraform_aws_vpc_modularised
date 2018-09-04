
/*
  Naming Convention Variables
*/

variable "pwc_aws_tag" {
  default = "PA"
}

variable "stamp" {
  default = "dev"
}

variable "account_type" {
  default = "non_prod"
}

variable "env" {
  default = "dev"
}

/*
  Provider Variables
*/

variable "access_key" {}

variable "secret_key" {}

variable "region" {}

variable "assume_role_id" {
  default = "091584917491"
}

variable "shared_service_account_id" {
  default = "734500581458"
}

variable "peer_vpcid" {
  default = "vpc-bf9df9c7"
}

variable "aws_security_admin_id" {
  default = "638514094130"
}

/*
  VPC
*/

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
}

variable "vpc_instance_tenancy" {
  description = "The tenancy of the VPC"
  
  default = "default"
}

/*
  Subnets
*/

variable "subnet_public_cidr_list" {
  type = "list"
  description = "The CIDR block list for the public subnets"
}

variable "subnet_private_cidr_list" {
  type = "list"
  description = "The CIDR block list for the private subnets"
}

variable "subnet_nat_cidr_list" {
  type = "list"
  description = "The CIDR block list for the nat subnets"
}

variable "route_vpc_peering_cidr_block" {
  description = "The CIDR block to route to the VPC Peering connection"
  
  default = "10.0.0.0/8"
}

variable "availability_zones_list" {
  type = "list"
  description = "The list of availability zones to be used"
}

/*
  Logging
*/

variable "cloudwatch_subscription_filter_name" {
  default = "AllCloudTrailLogsFilter"
}

variable "cloudwatch_filter_pattern" {
  default = ""
}

variable "iam_policies_url" {
  default = "https://github.pwc.com/raw/NIS-Cloud-Security/AWS/master/IAM_Policies"
}

variable "github_iam_token" {}

variable "cw_syslog_group" {
  default = "SYSLOGS"
}

variable "cw_flowlogs_retention_days" {
  description = "The number of days, the flow log events will remain retained"

  default = 1
}  

variable "cw_syslogs_retention_days" {
  description = "The number of days, the EC2 log events will remain retained"

  default = 1
}

/*
  AWS Config
*/

variable "config_s3_bucket" {
  type = "map"
  
  default = {
    "dev"   = "pa-as3-d-ue1-s-buc-p-sec-001"
    "stage" = "pa-as3-s-ue1-s-buc-p-sec-001"
  }
}

variable "sns_config_topic_arn" {
  type = "map"
  default = {
    "us-east-1" =  "arn:aws:sns:us-east-1:638514094130:PA-SNS-ConfigTopic-d-ue1-001"
    "us-east-2" =  "arn:aws:sns:us-east-2:638514094130:PA-SNS-ConfigTopic-d-ue2-001"
    "us-west-1" =  "arn:aws:sns:us-west-1:638514094130:PA-SNS-ConfigTopic-d-uw1-001"
    "us-west-2" =  "arn:aws:sns:us-west-2:638514094130:PA-SNS-ConfigTopic-d-uw2-001"
  }
}

variable "all_config_supported_bool" {
  description = "Boolean Variable for all supported types in AWS config"
  
  default     = "true"
}

variable "is_config_enabled_bool" {
  description = "Turn on/off AWS Config"
  
  default     = "true"
}

/*
  Tag Names
*/

variable "vpc_name" {
  description = "The tag name for VPC"
}

variable "internet_gateway_name" {
  description = "The tag name for Internet Gateway"
}

variable "subnet_public_name_list" {
  type = "list"
}

variable "route_public_name_list" {
  type = "list"
}

variable "subnet_private_name_list" {
  type = "list"
}

variable "route_private_name_list" {
  type = "list"
}

variable "subnet_nat_name_list" {
  type = "list"
}

variable "route_nat_name_list" {
  type = "list"
}

variable "eip_name_list" {
  type = "list"
}

variable "nat_name_list" {
  type = "list"
}

variable "vpc_peer_requester_name" {
  description = "The tag name for VPC Peering"
}

variable "public_nacl_name" {
  description = "The tag name for Public NACL"
}

variable "nat_nacl_name" {
  description = "The tag name for NAT NACL"
}

variable "private_nacl_name" {
  description = "The tag name for Private NACL"
}

variable "security_group_vpc_name" {
  default = "Do_not_use"
}

variable "cloudwatch_flow_log_name" {
  description = "The name for CloudWatch Flow Log Group"
}

variable "iam_flowlog_role_name" {
  description = "The tag name for IAM Role for Flow Logs"
}

variable "iam_flowlog_policy_name" {
  description = "The tag name for IAM Policy for Flow Logs"
}

variable "iam_aws_config_role_name" {
  description = "The tag name for IAM Role for AWS Config"
}

variable "aws_config_recorder_name" {
  description = "The tag name for AWS Config Recorder"
}

variable "aws_config_s3_delivery_channel_name" {
  default = "aws_config_delivery_channel"

  description = "The tag name for AWS Config Delivery Channel"
}

variable "config_s3_prefix" {
  default = "config"
}

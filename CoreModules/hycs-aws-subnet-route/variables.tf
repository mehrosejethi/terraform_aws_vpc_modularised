variable "vpc_id" {
    description = "The id of the VPC"
}

variable "availability_zones_list" {
    type = "list"
    description = "The list of availability zones in which subnets are created"
}

variable "subnet_cidr_blocks_list" {
    type = "list"
    description = "The list of CIDR blocks for the subnets"
}

variable "public_subnet_bool" {
    type = "map"
    description = "To declare a subnet private or public"

    default = {
        "public"    = true
        "private"   = false
        "nat"       = false
    }
}

variable "subnet_type" {
    description = "The type of subnet to be created"
}

variable "internet_gateway_id" {
    default = "InternetGatewayIdNotProvided"
    description = "The id of the Internet Gateway generated"
}

variable "nat_gateway_id_list" {
    type = "list"
    default = ["NatGatewayIdNotProvided"]
    description = "The list of the Internet Gateway created"
}

variable "vpc_peering_cidr_block" {
    default = "VpcPeeringCidrNotProvided"
    description = "The CIDR block of the VPC to be peered along"
}

variable "vpc_peer_requester_id" {
    default = "VpcPeeringIdNotProvided"
    description = "The ID of the VPC Peering connection"
}

variable "subnet_name_list" {
    type = "list"
    description = "The tag name list for the Subnets"
}

variable "route_name_list" {
    description = "The tag name list for the Route Tables"
    type = "list"
}
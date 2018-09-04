variable "availability_zones_list" {
    type = "list"
    description = "The list of availability zones in which subnets are created"
}

variable "public_subnet_ids" {
    type = "list"
    description = "The list of public subnets id's"
}

variable "eip_name_list" {
    type = "list"
    description = "The tag name for the Elastic IP's"
}

variable "nat_name_list" {
    type = "list"
    description = "The tag name for the NAT Gateways"
}

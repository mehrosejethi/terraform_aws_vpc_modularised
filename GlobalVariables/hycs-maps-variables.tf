/*
  Naming Convention Maps
*/

variable "resource_type_tag" {
  type = "map"
  
  default = {
    "vpc"				= "VPC"
    "internet_gateway"	= "IGW"
    "subnet"			= "SNT"
    "route_table"		= "RTB"
    "nat_gateway"		= "NGW"
    "elastic_ip"		= "EIP"
    "vpc_peering"		= "VPR"
    "nacl"				= "NAC"
    "cw_log_group"		= "CLG"
    "iam_role"			= "ROL"
    "iam_policy"		= "POL"
	
  }
}

variable "stamp_tag" {
  type = "map"
  
  default = {
    "dev"		 = "D"
    "stage" 	 = "S"
    "production" = "P"
  }
}

variable "region_tag" {
  type = "map"
  
  default = {
    "us-east-1" = "UE1"
  }
}

variable "account_type_tag" {
  type = "map"
  
  default = {
    "non_prod"			     = "N"
    "production"		     = "P"
    "explorer"		    	 = "E"
    "security"	    		 = "S"
    "it_shared_services" = "I"
  }
}

variable "availability_zone_tag" {
  type = "map"
  
  default = {
    "zone_a" = "A"
    "zone_b" = "B"
    "zone_c" = "C"
  }
}

variable "subnet_type_tag" {
  type = "map"
  
  default = {
    "public"	= "PB"
    "private"	= "PR"
    "nat"	  	= "NT"
  }
}

variable "env_tag" {
  type = "map"
  
  default = {
    "dev"		      = "D"
	  "stage" 	    = "S"
	  "production"  = "P"
	  "test"	   	  = "T"
	  "qa"		      = "QA"
  }
}

variable "nacl_type_tag" {
  type = "map"
  
  default = {
    "public"	= "PB"
    "private"	= "PR"
    "nat" 		= "NT"
  }
}
variable "cidr_block" {}

variable "vpc_name" {}

variable "subnets_cidr_block" {
     type =list 
}

variable "subnets_az" {
     type = list
}

variable "subnet_name" {}

variable "route_name" {}
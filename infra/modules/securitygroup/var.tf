variable "sg_name" {}

variable "sg_vpc_id" {}


variable "num_of_rules" {
    type = number
    }

variable "rule_type" {
    type = list
     }

variable "from_port" {
    type = list(number)
     }

variable "to_port" {
    type = list(number)
     }

variable "protocol" {
    type = list
     }

variable "sg_cidr_blocks" {
    type = list
     }

















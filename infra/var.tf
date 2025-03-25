// vpc module var 
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
//

// ecs cluster var
variable "ecs_cluster_name" {}
variable "ecs_instance_name" {}
variable "ecs_instance_type" {}
variable "ecs_asg_min_size" {
    type =number
}
variable "ecs_asg_max_size" {
    type =number
}

// ecs instace securitygroup module var

variable "ecs_sg_name" {}
variable "ecs_num_of_rules" {
    type = number
    }
variable "ecs_rule_type" {
    type = list
     }
variable "ecs_from_port" {
    type = list(number)
     }
variable "ecs_to_port" {
    type = list(number)
     }
variable "ecs_protocol" {
    type = list
     }
variable "ecs_sg_cidr_blocks" {
    type = list
     }
//

// ecs task var
variable "ecs_task_family" {}

variable "ecs_container_name" {}


variable "ecs_container_cpu" {
    type = number
}
variable "ecs_container_memory" {
    type = number
}

variable "ecs_container_port" {
    type = number
}

variable "alb_name" {}

variable "lb_target_name"{}

variable "lb_target_port" {
    type = number
}

variable "lb_target_protocol" {}


variable "lb_target_health_check" {}
//


// alb securitygroup var
variable "alb_sg_name" {}
variable "alb_num_of_rules" {
    type = number
    }
variable "alb_rule_type" {
    type = list
     }
variable "alb_from_port" {
    type = list(number)
     }
variable "alb_to_port" {
    type = list(number)
     }
variable "alb_protocol" {
    type = list
     }
variable "alb_sg_cidr_blocks" {
    type = list
     }
//

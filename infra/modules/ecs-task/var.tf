variable "ecs_task_family" {}

variable "ecs_container_name" {}

variable "app_image" {}

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

variable "alb_sg" {
    type = list
}
variable "alb_subnets" {
    type = list
}

variable "lb_target_name"{}

variable "lb_target_port" {
    type = number
}

variable "lb_target_protocol" {}

variable "lb_vpc_id" {}

variable "lb_target_health_check" {}
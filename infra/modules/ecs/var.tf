variable "ecs_cluster_name" {}

variable "ecs_instance_name" {}

variable "ecs_instance_type" {}

variable "ecs_instance_sg" {
    type = list
}

variable "ecs_asg_min_size" {
    type = number
}
variable "ecs_asg_max_size" {
    type = number
}
variable "ecs_asg_zone" {
    type = list
}
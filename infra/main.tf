module "nile_vpc"{
  source = "./modules/networks"
  cidr_block = var.cidr_block
  vpc_name = var.vpc_name
  subnets_cidr_block = var.subnets_cidr_block
  subnets_az=var.subnets_az
  subnet_name=var.subnet_name
  route_name=var.route_name
}

resource "aws_route_table_association" "a" {
  subnet_id      = module.nile_vpc.subnets_id[0]  
  route_table_id = module.nile_vpc.internet_route_table_id 
}

resource "aws_route_table_association" "b" {
  subnet_id      = module.nile_vpc.subnets_id[2]  
  route_table_id = module.nile_vpc.internet_route_table_id 
}
resource "aws_route_table_association" "c" {
  subnet_id      = module.nile_vpc.subnets_id[1]  
  route_table_id = module.nile_vpc.main_route_table_id 
}

module "ecs_cluster"{
  source ="./modules/ecs"
  ecs_cluster_name = var.ecs_cluster_name
  ecs_instance_name = var.ecs_instance_name
  ecs_instance_type = var.ecs_instance_type
  ecs_instance_sg = [module.ecs_sg.sg_id] 
  ecs_asg_min_size =var.ecs_asg_min_size
  ecs_asg_max_size = var.ecs_asg_max_size
  ecs_asg_zone = [module.nile_vpc.subnets_id[1]]
}

resource "local_file" "ecs_ssh_private_key" {
  content  = module.ecs_cluster.ecs_ssh_private_key
  filename = "key.txt"
}

module "ecs_sg"{
  source = "./modules/securitygroup"
  sg_name = var.ecs_sg_name
  sg_vpc_id=module.nile_vpc.vpc_id
  num_of_rules = var.ecs_num_of_rules
  rule_type = var.ecs_rule_type
  from_port = var.ecs_from_port
  to_port = var.ecs_to_port
  protocol = var.ecs_protocol
  sg_cidr_blocks = var.ecs_sg_cidr_blocks
}

module "ecs_task" {
  source = "./modules/ecs-task"
  ecs_task_family = var.ecs_task_family
  ecs_container_name = var.ecs_container_name
  app_image ="${aws_ecr_repository.hello.repository_url}:latest"
  ecs_container_cpu = var.ecs_container_cpu
  ecs_container_memory = var.ecs_container_memory
  ecs_container_port = var.ecs_container_port
  alb_name = var.alb_name
  alb_sg = [module.alb_sg.sg_id]
  alb_subnets = [module.nile_vpc.subnets_id[0],module.nile_vpc.subnets_id[2]]
  lb_target_name = var.lb_target_name
  lb_target_port = var.lb_target_port
  lb_target_protocol = var.lb_target_protocol
  lb_vpc_id = module.nile_vpc.vpc_id
  lb_target_health_check =var.lb_target_health_check
}

module "alb_sg"{
  source = "./modules/securitygroup"
  sg_name = var.alb_sg_name
  sg_vpc_id=module.nile_vpc.vpc_id
  num_of_rules = var.alb_num_of_rules
  rule_type = var.alb_rule_type
  from_port = var.alb_from_port
  to_port = var.alb_to_port
  protocol = var.alb_protocol
  sg_cidr_blocks = var.alb_sg_cidr_blocks
}


resource "aws_ecr_repository" "hello" {
  name = "hello"
}


resource "docker_image" "my-docker-image" {
  name = "${aws_ecr_repository.hello.repository_url}:latest"
  build {
    context = "../app"
  }
  platform = "linux/arm64"
}

resource "docker_registry_image" "media-handler" {
  name = docker_image.my-docker-image.name
}




resource "aws_ecs_service" "hello_service" {
  name            = "api-service"
  cluster         = module.ecs_cluster.ecs_id
  task_definition = module.ecs_task.task_definition_arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = module.ecs_task.alb_target_group_arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }
}


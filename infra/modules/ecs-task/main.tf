resource "aws_ecs_task_definition" "main" {
  family                   = var.ecs_task_family
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.ecs_container_name}",
      image     = "${var.app_image}",
      cpu       = var.ecs_container_cpu,
      memory    = var.ecs_container_memory,
      essential = true,
      portMappings = [
        {
          containerPort = var.ecs_container_port,
        }
      ]
    }
  ])
}

resource "aws_lb" "app" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg
  subnets            = var.alb_subnets
}

resource "aws_lb_target_group" "app-target" {
  name     = var.lb_target_name
  port     = var.lb_target_port
  protocol = var.lb_target_protocol
  vpc_id   = var.lb_vpc_id

target_type = "instance"
  health_check {
    path                = var.lb_target_health_check
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = var.lb_target_port
  protocol          = var.lb_target_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-target.arn
  }
}



resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs_task_execution_policy_attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

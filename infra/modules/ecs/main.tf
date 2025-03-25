resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
  tags = {
    name = var.ecs_cluster_name
  }
}

data "aws_ami" "stable_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ecs-optimized*"]
  }

  owners      = ["amazon"]
}

resource "aws_launch_template" "ecs_instance" {
  name_prefix   = var.ecs_instance_name
                #  ami-0b5a7998795f497af
  image_id      = "${data.aws_ami.stable_ecs.id}" 
  instance_type = var.ecs_instance_type
  key_name = aws_key_pair.ecs_key.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups = var.ecs_instance_sg
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
              EOF
              )
}


resource "aws_autoscaling_group" "ecs_asg" {
  min_size             = var.ecs_asg_min_size
  max_size             = var.ecs_asg_max_size
  vpc_zone_identifier  = var.ecs_asg_zone
  health_check_type    = "EC2"
  launch_template {
    id      = aws_launch_template.ecs_instance.id
    version = "$Latest"
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ecs_instance_policy" {
  name       = "ecs_instance_policy_attachment"
  roles      = [aws_iam_role.ecs_instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}


resource "tls_private_key" "ecs_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ecs_key" {
  key_name   = "ecs"
  public_key = "${tls_private_key.ecs_key.public_key_openssh}"
}
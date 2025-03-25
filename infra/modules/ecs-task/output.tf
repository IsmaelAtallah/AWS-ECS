output "task_definition_arn"{
    value =aws_ecs_task_definition.main.arn
}

output "alb_target_group_arn"{
    value =aws_lb_target_group.app-target.arn
}
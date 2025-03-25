output "ecs_id" {
    value = aws_ecs_cluster.main.id
}

output "ecs_ssh_private_key" {
    value = tls_private_key.ecs_key.private_key_pem
}
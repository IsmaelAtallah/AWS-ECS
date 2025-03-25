output "vpc_id" {
  value = aws_vpc.main.id
}

output "main_route_table_id" {
  value = aws_vpc.main.main_route_table_id
}

output "internet_route_table_id" {
  value = aws_route_table.internet.id
}

output "subnets_id"{
    value =aws_subnet.subnets[*].id
}

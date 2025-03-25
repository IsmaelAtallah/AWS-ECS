resource "aws_security_group" "main" {
  name        = var.sg_name
  vpc_id      = var.sg_vpc_id

  tags = {
    Name = var.sg_name
  }
}
resource "aws_security_group_rule" "main" {
  count             = var.num_of_rules
  type              = var.rule_type[count.index]
  from_port         = var.from_port[count.index]
  to_port           = var.to_port[count.index]
  protocol          = var.protocol[count.index]
  cidr_blocks       = var.sg_cidr_blocks
  security_group_id = aws_security_group.main.id
}

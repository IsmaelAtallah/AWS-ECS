resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_eip" "nat_ip" {
  tags = {
    name = "NAT-IP"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.subnets[0].id

  tags = {
    Name = "gw NAT"
  }
}


resource "aws_subnet" "subnets" {
  count = length(var.subnets_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets_cidr_block[count.index]
  availability_zone = var.subnets_az[count.index]
  tags = {
    Name = "${var.subnet_name}_${count.index}"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.route_name
  }
}







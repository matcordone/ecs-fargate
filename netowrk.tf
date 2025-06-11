resource "aws_vpc" "vpc_1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-ECS"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 0)
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 1)
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

resource "aws_subnet" "subnet_pub" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_1.cidr_block, 8, 2)
  availability_zone = "us-east-1c"

  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }

}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "Internet-Gateway"
  }

}

resource "aws_route_table" "route_table_pub" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "route_table_association_pub" {
  subnet_id      = aws_subnet.subnet_pub.id
  route_table_id = aws_route_table.route_table_pub.id
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_pub.id

  tags = {
    Name = "NAT-Gateway"
  }

}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_route_table" "route_table_priv" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "rta_priv_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table_priv.id
}
resource "aws_route_table_association" "rta_priv_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table_priv.id
}

resource "aws_security_group" "sg_alb" {
  name        = "sg_alb"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = aws_vpc.vpc_1.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.sg_alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_http_egress" {
  security_group_id = aws_security_group.sg_alb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "sg_ecs" {
  name        = "sg_ecs"
  description = "Allow traffic from ALB to ECS tasks"
  vpc_id      = aws_vpc.vpc_1.id
}
resource "aws_vpc_security_group_ingress_rule" "ecs_alb_ingress" {
  security_group_id = aws_security_group.sg_ecs.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  referenced_security_group_id = aws_security_group.sg_alb.id
  description       = "Allow HTTP traffic from ALB to ECS tasks"
}
resource "aws_vpc_security_group_egress_rule" "ecs_alb_egress" {
  security_group_id = aws_security_group.sg_ecs.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
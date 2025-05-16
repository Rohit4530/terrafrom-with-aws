data "aws_vpc" "default" {
  default = true
}
moved {
  from = aws_subnet.allowed
  to   = aws_subnet.private1
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.custom.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
  tags = {
    Name   = "allowed-subnet-1"
    Access = "private"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name   = "allowed-subnet-2"
    Access = "private"
  }
}
resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-vpc"
  }
}
resource "aws_subnet" "not_allowed" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.128.0/24"
  tags = {
    Name = "not-allowed-subnet"
  }
}
resource "aws_security_group" "source" {
  name        = "source_sg"
  description = "security group from where the traffic is allowed"
  vpc_id      = aws_vpc.custom.id
}
resource "aws_security_group" "compliant" {
  name        = "compliant_sg"
  description = "security group from where the traffic is allowed"
  vpc_id      = aws_vpc.custom.id
}
resource "aws_security_group" "non-compliant" {
  name        = "non_compliant_sg"
  description = "security group from where the traffic is allowed"
  vpc_id      = aws_vpc.custom.id
}
resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.compliant.id
  referenced_security_group_id = aws_security_group.source.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.non-compliant.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

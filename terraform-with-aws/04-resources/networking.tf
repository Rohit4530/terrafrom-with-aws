locals {
  common_tags = {
    Name       = "04-resources-vpc"
    Managed_By = "terraform"
    Project    = "04-resources"
  }

}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    Name = "04-resources-vpc"
  })
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  tags = merge(local.common_tags, {
    Name = "04-resources-public-subnet"
  })
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "04-resources-igw"
  })
}
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, {
    Name = "04-resources-rtb"
  })
}
resource "aws_route_table_association" "rtb-association" {
  route_table_id = aws_route_table.rtb.id
  subnet_id      = aws_subnet.public.id
}
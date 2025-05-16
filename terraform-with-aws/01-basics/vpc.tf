resource "aws_vpc" "my-demo-vpc" {
cidr_block = "10.0.0.0/16"
  tags = {
    Name="my-demo-vpc"
  }
}
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.my-demo-vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name="my-public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.my-demo-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name="my-private-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-demo-vpc.id
  tags = {
    Name="my-internet-gateway"
  }
}
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.my-demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name="my-route-table"
  }
}
resource "aws_route_table_association" "route-table-association" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id = aws_subnet.public-subnet.id
}
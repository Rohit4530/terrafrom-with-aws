resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.Project}-vpc"
  }
}
locals {
  Project = "09-multiple-resource"
  ec2_config_list=[{
    "instance_type"="t2.micro",
    "ami"="ubuntu"
  },{
    "instance_type"="t2.micro",
    "ami"="nginx"
  }]
  ami_ids={
    "ubuntu"=data.aws_ami.ubuntu.id,
    "nginx"=data.aws_ami.nginx.id
  }

}
resource "aws_subnet" "default" {
  count      = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  tags = {
    Name = "${local.Project}-subnet-${count.index}"
  }
}
resource "aws_instance" "web" {
  count                       = length(local.ec2_config_list)
  ami                         = local.ami_ids[local.ec2_config_list[count.index].ami]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.default[count.index % length(local.ec2_config_list)].id
  instance_type               = local.ec2_config_list[count.index].instance_type
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
  tags = {
    Name = "09-resource-ec2-instance-${count.index}"
  }
}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
data "aws_ami" "nginx" {

  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.28.0-linux-debian-12-x86_64-hvm-ebs-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

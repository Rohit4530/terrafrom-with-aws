resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.default.id
  instance_type               = "t2.micro"
  root_block_device {
    delete_on_termination = true
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }
  tags = {
    Name = "06-resource-ec2-instance"
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


data "aws_subnet" "default" {
}

data "aws_region" "current" {}
data "aws_availability_zones" "zone" {

}
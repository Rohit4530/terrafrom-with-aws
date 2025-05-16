resource "aws_instance" "default" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.default.id
}

data "aws_subnet" "default"{

}


data "aws_ami" "ubuntu" {

most_recent = true

filter {
name   = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}

filter {
name = "virtualization-type"
values = ["hvm"]
}

owners = ["099720109477"]
}


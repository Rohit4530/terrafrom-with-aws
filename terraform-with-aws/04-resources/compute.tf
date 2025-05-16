resource "aws_instance" "ec2_instance" {
  ami                         = "ami-089cb80aef4c6b37e"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  instance_type               = "t2.micro"
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
  tags = merge(local.common_tags, {
    Name = "04-resource-ec2-instance"
  })
}
resource "aws_security_group" "sg" {
  description = "Allow traffic from port 80 and 443"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "04-project-sg"
  })
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "https" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}
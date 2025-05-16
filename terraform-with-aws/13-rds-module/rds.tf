module "database" {
  source = "./modules/rds"
  security_group_ids = [
    aws_security_group.compliant.id
  ]
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
  cred = {
    username = "dbadmin"
    password = "rohit4530"
  }

}
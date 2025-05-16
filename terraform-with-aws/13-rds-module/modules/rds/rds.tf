locals {
  db_engine={
    postgres-latest={
      engine="postgres"
      version="16.3"
      family="postgres16"
    }
    postgres-14={
      engine="postgres"
      version="14.11"
      family="postgres14"
    }

  }

}
resource "aws_db_subnet_group" "this" {
  name = var.project_name
  subnet_ids = var.subnet_ids
  tags = {
    Name=var.project_name
  }
}
resource "aws_db_instance" "db" {
  instance_class = var.instance_class
  identifier = var.project_name
  allocated_storage = var.storage_size
  engine = local.db_engine[var.engine].engine
  engine_version = local.db_engine[var.engine].version
  username = var.cred.username
  password = var.cred.password
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible = false
  skip_final_snapshot = true
}
resource "aws_db_parameter_group" "db_parameter_group" {
  name = var.project_name
  family = local.db_engine[var.engine].family
  parameter {
    name  = "log_connections"
    value = "1"
  }

}
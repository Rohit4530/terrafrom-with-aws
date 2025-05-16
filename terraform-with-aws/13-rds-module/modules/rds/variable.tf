variable "project_name" {
  type = string
  default = "rds-module"
}
variable "instance_class" {
  type = string
  default = "db.t3.micro"
  validation {
    condition     = contains(["db.t3.micro"], var.instance_class)
    error_message = "only db.t3.micro is allowed"
  }
}
variable "storage_size" {
  type = number
  default = 5
  validation {
    condition     = var.storage_size >= 5 && var.storage_size <= 10
    error_message = "db storage must be between 5 to 10"
  }
}
variable "engine" {
  type = string
  default = "postgres-latest"
  validation {
    condition     = contains(["postgres-latest", "postgres-14"], var.engine)
    error_message = "db engine must be postgres-latest or postgres-14"
  }
}
variable "cred" {
  type = object({
    username=string,
    password=string
  })
  sensitive = true
  validation {
    condition = length(var.cred.password)>6
    error_message = "password should be at least of 6 characters"
  }
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
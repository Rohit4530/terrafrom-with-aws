variable "aws_region" {
  type = string
}
variable "volume_size" {
  type        = number
  description = "size of EBS volume"
}
variable "volume_type" {
  type        = string
  description = "type of EBS volume"
}
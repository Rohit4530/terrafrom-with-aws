output "aws_caller" {
  value = data.aws_caller_identity.current
}
output "aws_region" {
  value = data.aws_region.current.id
}
output "az" {
  value = data.aws_availability_zones.zone.names[*]
}
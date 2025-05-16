resource "random_id" "suffix" {
  byte_length = 6
}
output "val" {
  value = random_id.suffix.hex
}
resource "aws_s3_bucket" "random_bucket" {
  bucket = "my-random-bucket-${random_id.suffix.hex}"
}
resource "aws_s3_bucket" "sample" {
  bucket = "sample-bucket-${terraform.workspace}-${random_id.suffix.hex}"
}
resource "random_id" "suffix" {
  byte_length = 8
}
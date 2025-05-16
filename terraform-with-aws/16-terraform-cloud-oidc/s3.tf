resource "aws_s3_bucket" "sample_bucket" {
  bucket = "my-new-sample-bucket-${random_id.suffix.hex}"
}
resource "random_id" "suffix" {
  byte_length = 6
}
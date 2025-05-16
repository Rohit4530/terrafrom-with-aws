resource "aws_s3_bucket" "my_sample_bucket" {
  bucket = "my-s3-bucket-${random_id.bucket_suffix.hex}"
}

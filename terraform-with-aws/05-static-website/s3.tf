resource "aws_s3_bucket" "static_website" {
  bucket = "static-website-${random_id.suffix.hex}"
}
resource "random_id" "suffix" {
  byte_length = 6
}
resource "aws_s3_bucket_public_access_block" "disable_access_block" {
  bucket = aws_s3_bucket.static_website.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}
resource "aws_s3_bucket_website_configuration" "bucket_config" {
  bucket = aws_s3_bucket.static_website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.html"
  source = "build/index.html"
  etag = filemd5("build/index.html")
  content_type = "text/html"
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.static_website.id
  key    = "error.html"
  source = "build/error.html"
  etag = filemd5("build/error.html")
  content_type = "text/html"
}

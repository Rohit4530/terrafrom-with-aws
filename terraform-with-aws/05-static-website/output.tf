output "s3_public_url" {
  value = aws_s3_bucket.static_website.website_endpoint
}
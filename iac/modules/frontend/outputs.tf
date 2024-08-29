output "distribution" {
  value = aws_cloudfront_distribution.s3_distribution
}

output "bucket" {
  value = module.frontend_bucket
}

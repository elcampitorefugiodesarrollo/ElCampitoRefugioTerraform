output "cloudfront_url" {
  value = module.frontend.distribution.domain_name
}

output "bucket_name" {
  value = module.frontend.bucket.bucket_name
}
output "cloudfront_url" {
  value = module.frontend.distribution.domain_name
}

output "bucket_name" {
  value = module.frontend.bucket.s3_bucket_id
}

output "image_uri" {
  value = local.backend_container_image
}

output "mongodb_endpoint" {
  value = length(module.db) >= 1 ? module.db[0].endpoint : "Not created"
}

output "backend_endpoint" {
  value = length(module.backend) >= 1 ? module.backend[0].endpoint : "Not created"
}

output "mongodb_user" {
  value = length(module.db) >= 1 ? module.db[0].username : "Not created"
}
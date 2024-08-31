locals {
  azs                     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  env_name                = "dev"
  image_tag               = "0.0.1"
  backend_container_image = "${module.ecr_backend.repository.repository_uri}:${local.image_tag}"
  # Las IPs de los devs como CIDR
  allowed_cidrs        = ["98.164.211.4/32"] # Obtene la tuya con "curl ifconfig.me"
  crear_recursos_caros = true
}
# Usar para produccion
module "backend" {
  count         = local.crear_recursos_caros ? 1 : 0
  source        = "../../modules/app-runner"
  name          = local.env_name
  port          = 80
  image_tag     = local.backend_container_image
  vpc_id        = module.vpc[0].vpc_id
  subnet_ids    = module.vpc[0].private_subnets
  allowed_cidrs = local.allowed_cidrs
  allowed_sgs   = [aws_security_group.cloudshell[0].id]
}

# Usar para desarrollo
#module "dev" {
#  source = "../../modules/ec2-aio"
#  subnet_id = module.vpc.public_subnets[0]
#  ips_permitidas = ["98.164.211.4"] # Obtene la tuya con "curl ifconfig.me"
#}
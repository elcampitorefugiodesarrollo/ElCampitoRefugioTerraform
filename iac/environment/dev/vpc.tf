module "vpc" {
  count                  = local.crear_recursos_caros ? 1 : 0
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.13.0"
  name                   = local.env_name
  cidr                   = "10.0.0.0/16"
  azs                    = local.azs
  private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets         = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  database_subnets       = ["10.0.100.0/24", "10.0.101.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

# Para que los devs puedan acceder a mongodb
resource "aws_security_group" "cloudshell" {
  count       = local.crear_recursos_caros ? 1 : 0
  vpc_id      = module.vpc[0].vpc_id
  description = "Para usar desde Cloudshell"
  egress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
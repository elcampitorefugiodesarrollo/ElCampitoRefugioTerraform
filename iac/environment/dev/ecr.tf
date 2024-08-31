module "ecr_backend" {
  source                 = "../../modules/ecr"
  repository_name        = "${local.env_name}-backend"
  repository_description = "Repositorio para imagenes de backend"
}
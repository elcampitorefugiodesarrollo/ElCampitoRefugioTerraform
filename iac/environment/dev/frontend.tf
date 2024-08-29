module "frontend" {
  source = "../../modules/frontend"
  environment_name = local.env_name
}
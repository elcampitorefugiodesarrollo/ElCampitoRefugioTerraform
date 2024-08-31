module "db" {
  count       = local.crear_recursos_caros ? 1 : 0
  source      = "../../modules/documentdb"
  name        = local.env_name
  subnet_ids  = module.vpc[0].database_subnets
  vpc_id      = module.vpc[0].vpc_id
  sg_ids      = [module.backend[0].security_group, aws_security_group.cloudshell[0].id]
  db_password = var.db_password
}
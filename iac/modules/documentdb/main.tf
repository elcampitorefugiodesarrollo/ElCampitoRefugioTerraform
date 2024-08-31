resource "aws_docdb_cluster" "this" {
  cluster_identifier      = var.name
  engine                  = "docdb"
  master_username         = "adminuser"
  master_password         = var.db_password
  backup_retention_period = 1
  preferred_backup_window = "03:00-05:00" #UTC
  skip_final_snapshot     = true
  apply_immediately       = true
  vpc_security_group_ids  = toset([aws_security_group.doc_db.id])
  db_subnet_group_name    = aws_docdb_subnet_group.this.name
}

resource "aws_docdb_cluster_instance" "this" {
  identifier         = "docdb-cluster-${var.name}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = "db.t4g.medium"
}

resource "aws_docdb_subnet_group" "this" {
  name       = "main"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "doc_db" {
  vpc_id = var.vpc_id
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = var.sg_ids
  }
}

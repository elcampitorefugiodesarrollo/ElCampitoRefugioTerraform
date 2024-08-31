output "endpoint" {
  value = aws_docdb_cluster_instance.this.endpoint
}

output "security_group" {
  value = aws_security_group.doc_db.id
}

output "username" {
  value = aws_docdb_cluster.this.master_username
}

output "password" {
  value = aws_docdb_cluster.this.master_password
}
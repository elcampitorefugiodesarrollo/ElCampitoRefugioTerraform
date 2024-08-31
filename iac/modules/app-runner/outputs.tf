output "endpoint" {
  value = aws_apprunner_service.this.service_url
}

output "security_group" {
  value = aws_security_group.app_runner.id
}
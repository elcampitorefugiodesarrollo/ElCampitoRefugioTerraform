resource "aws_apprunner_service" "this" {
  service_name = "backend-${var.name}"
  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "512"
  }
  health_check_configuration {
    protocol = "HTTP"
    path     = "/"
    interval = 5
  }
  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }


  source_configuration {
    image_repository {
      image_configuration {
        port = var.port
      }
      image_identifier      = var.image_tag
      image_repository_type = "ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn
}

resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  auto_scaling_configuration_name = "${var.name}-0"
  max_concurrency                 = 100
  max_size                        = 1
  min_size                        = 1
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.name}-connector"
  subnets            = var.subnet_ids
  security_groups    = toset([aws_security_group.app_runner.id])
}

resource "aws_security_group" "app_runner" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }
  ingress {
    security_groups = var.allowed_sgs
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
  }
  egress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

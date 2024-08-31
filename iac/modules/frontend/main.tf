module "frontend_bucket" {
  source                   = "terraform-aws-modules/s3-bucket/aws"
  version                  = "4.1.2"
  bucket                   = "el-campito-refugio-${var.environment_name}-frontend"
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"
  attach_policy            = true
  policy                   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${module.frontend_bucket.s3_bucket_arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        }
    ]
}
  EOF
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = module.frontend_bucket.s3_bucket_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = var.environment_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.environment_name
  default_root_object = "index.html"

  # Cuando tengamos dominios para el ambiente,
  #aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.environment_name

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cambiar a PriceClass_ALL para servir desde argentina (mas caro)
  price_class = "PriceClass_100"

  # En el futuro confirmar que solo se sirve de argentina para restringir paises donde no es relevante el contenido

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # En el futuro confirmar que solo se sirve de argentina para restringir paises donde no es relevante el contenido
      #restriction_type = "whitelist"
      #locations        = ["AR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.environment_name}-frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


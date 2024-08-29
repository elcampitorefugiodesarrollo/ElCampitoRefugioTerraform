resource "aws_iam_user" "github_actions_user" {
  name = "svc-github-actions"
  path = "/automation/"
}

resource "aws_iam_role" "github-actions" {
  name = "github-actions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/${aws_iam_user.github_actions_user.name}"
        }
      },
    ]
  })
    managed_policy_arns = []
}

resource "aws_iam_policy" "ecr_push" {
  name        = "ecr_push"
  path        = "/github-actions/"
  description = "Permite que github actions suba imagenes a ECR"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
                "ecr-public:CompleteLayerUpload",
                "ecr-public:UploadLayerPart",
                "ecr-public:InitiateLayerUpload",
                "ecr-public:BatchCheckLayerAvailability",
                "ecr-public:PutImage"
            ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
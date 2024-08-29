resource "aws_ecrpublic_repository" "this" {
  repository_name = var.repository_name

  catalog_data {
    about_text        = var.repository_description
    description       = var.repository_description
    operating_systems = ["Linux"]
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "Restringir acceso a usuarios dentro de la cuenta de AWS"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.id]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecrpublic_repository_policy" "this" {
  repository_name = aws_ecrpublic_repository.this.repository_name
  policy          = data.aws_iam_policy_document.this.json
}
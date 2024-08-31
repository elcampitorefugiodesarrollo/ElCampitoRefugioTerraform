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
      type = "AWS"
      identifiers = [
        # TU USUARIO TIENE QUE ESTAR ACA PARA PODER SUBIR IMAGENES A ECR @REF:1
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/franco_martin"
      ]
    }

    actions = [
      "ecr-public:GetDownloadUrlForLayer",
      "ecr-public:BatchGetImage",
      "ecr-public:BatchCheckLayerAvailability",
      "ecr-public:PutImage",
      "ecr-public:InitiateLayerUpload",
      "ecr-public:UploadLayerPart",
      "ecr-public:CompleteLayerUpload",
      "ecr-public:DescribeRepositories",
      "ecr-public:GetRepositoryPolicy",
      "ecr-public:ListImages",
      "ecr-public:DeleteRepository",
      "ecr-public:BatchDeleteImage",
      "ecr-public:SetRepositoryPolicy",
      "ecr-public:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecrpublic_repository_policy" "this" {
  repository_name = aws_ecrpublic_repository.this.repository_name
  policy          = data.aws_iam_policy_document.this.json
}
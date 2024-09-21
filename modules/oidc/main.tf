resource "aws_iam_openid_connect_provider" "github_oidc_provider" {
  url = var.oidc_provider_url

  client_id_list = var.client_id_list

  thumbprint_list = var.thumbprint_list
  tags = {
    env = "${var.env}"
    name = "${var.project_name}-${var.env}-oidc-provider"
  }
}

resource "aws_iam_role" "oidc_role" {
  name = "${var.project_name}-${var.env}-oidc-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc_provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_organisation}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
          }
        }
      }
    ]
  })

  tags = {
    env = "${var.env}"
    name = "${var.project_name}-${var.env}-oidc-role"
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.project_name}-${var.env}-ecr-access-policy"
  description = "Policy to allow ECR access for CI/CD"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          #"ecr:CreateRepository",
          #"ecr:DeleteRepository"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  policy_arn = aws_iam_policy.ecr_policy.arn
  role       = aws_iam_role.oidc_role.name  # Remplace par le nom de ton rôle existant
}
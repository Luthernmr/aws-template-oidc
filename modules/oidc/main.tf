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

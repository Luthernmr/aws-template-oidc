resource "aws_iam_openid_connect_provider" "github_oidc_provider" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Version : "2012-10-17",
        Statement : [
          {
            Effect : "Allow",
            Principal : {
              Federated : aws_iam_openid_connect_provider.github_oidc_provider.arn
            },
            Action : "sts:AssumeRoleWithWebIdentity",
            Condition : {
              StringEquals : {
                "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
                "token.actions.githubusercontent.com:sub" : "repo:${var.github_organisation}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
              }
        } }]
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

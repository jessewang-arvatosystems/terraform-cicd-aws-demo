resource "aws_iam_openid_connect_provider" "github-oidc" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
  ]
}

resource "aws_iam_role" "github-oidc-role" {
  name = var.github_oidc_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Sid    = ""
        Principal : {
          Federated : aws_iam_openid_connect_provider.github-oidc.arn
        },
        Condition : {
          StringLike : {
            "token.actions.githubusercontent.com:sub" : "repo:jessewang-arvatosystems/trigger-terraform-aws-ci-cd:*"
          }
        }
      }
    ]
  })
}

output "github_oidc_role_arn" {
  description = "Github provider ARN"
  value       = aws_iam_role.github-oidc-role.arn
}

resource "aws_iam_role_policy_attachment" "github-policy-attachment1" {
  policy_arn = aws_iam_policy.codebuild-policy.arn
  role       = aws_iam_role.github-oidc-role.id
}

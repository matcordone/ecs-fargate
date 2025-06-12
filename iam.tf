data "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"
  
}

resource "aws_iam_role" "oidc" {
    name = "GitHubOIDCRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRoleWithWebIdentity",
                Effect = "Allow",
                Principal = {
                    Federated = data.aws_iam_openid_connect_provider.github.arn
                },
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:sub" = "repo:matcordone/ecs-fargate:ref:refs/heads/main"
                    }
                }
            }
        ]
    })
    
    tags = {
        Name = "GitHub-OIDC-Role"
    }
  
}

resource "aws_iam_policy_attachment" "ecr" {
    name       = "ECRAccessPolicyAttachment"
    roles      = [aws_iam_role.oidc.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_policy_attachment" "ecs" {
    name       = "ECSAccessPolicyAttachment"
    roles      = [aws_iam_role.oidc.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
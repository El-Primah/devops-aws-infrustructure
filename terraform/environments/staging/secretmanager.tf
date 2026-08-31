resource "aws_secretsmanager_secret" "eks_secret_mysql" {
  name = "mysql-staging"
}

resource "aws_secretsmanager_secret" "eks_secret_mongo" {
  name = "mongo-staging"
}

resource "aws_secretsmanager_secret" "eks_secret_group1_redis" {
  name = "group1-redis-staging"
}

resource "aws_iam_role_policy" "eks_node_group_secrets_ro_access" {
  name = "secretmanager-access-read-only"
  role = aws_iam_role.on_demand_eks_node_group.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = [
            aws_secretsmanager_secret.eks_secret_mysql.arn,
            aws_secretsmanager_secret.eks_secret_mongo.arn,
            aws_secretsmanager_secret.eks_secret_group1_redis.arn
        ]
      }
    ]
  })
}
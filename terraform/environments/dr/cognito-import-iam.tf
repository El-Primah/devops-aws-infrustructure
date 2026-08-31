# IAM role and policy for CloudWatch logs for importing Users to Cognito DR user pool
resource "aws_iam_role" "cognito_import_role" {
  name = "cognito-user-import-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cognito_import_policy" {
  name = "cognito-user-import-policy"
  role = aws_iam_role.cognito_import_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/cognito/*"
      }
    ]
  })
}

output "cognito_cor_item_import_role_arn" {
  value = aws_iam_role.cognito_import_role.arn
}

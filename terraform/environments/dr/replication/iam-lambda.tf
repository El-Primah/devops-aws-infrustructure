# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "dr-copy-snapshot-lambda-role"
  }
}

# IAM policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "dr-copy-snapshot-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBSnapshots",
          "rds:CopyDBSnapshot",
          "rds:DeleteDBSnapshot"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:generateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = [
          "arn:aws:kms:${data.aws_region.current.name}:${var.eu_west_1_prod_account_id}:key/58f9bf34-3f1c-4141-9889-e770cbea5b1a",
          "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/aws/rds"
        ]
      }
    ]
  })
}

# ==================== cognito-code-template LAMBDA ====================

# Lambda function cognito-code-template for cognito abc && cor_item
resource "aws_lambda_function" "cognito_code_template" {
  filename        = data.archive_file.cognito_code_template_zip.output_path
  function_name   = var.cognito_code_template
  role            = aws_iam_role.lambda_congito_role.arn
  handler         = "index.handler"
  runtime         = "nodejs14.x"
  timeout         = 3
  memory_size     = 128

  source_code_hash = data.archive_file.cognito_code_template_zip.output_base64sha256
}

# Create zip file from source code
data "archive_file" "cognito_code_template_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/cognito_code_template/index.js"
  output_path = "${path.module}/zip_code/cognito_code_template_payload.zip"
}

# ==================== SHARED LAMBDA IAM RESOURCES ====================

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_congito_role" {
  name = var.lambda_congito_role
  path = var.service_role_iam_resources_path

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
}

# IAM policies for cognito Lambda
resource "aws_iam_policy" "lambda_congito_basic_execution_policy" {
  name = var.lambda_congito_basic_execution_policy
  path = var.service_role_iam_resources_path
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
			"logs:CreateLogStream",
			"logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cognito_code_template.arn}:*"
      }
    ]
  })
}

# IAM policiy Attachments for cognito lambda
resource "aws_iam_role_policy_attachment" "lambda_congito_basic_execution_policy" {
  role       = aws_iam_role.lambda_congito_role.name
  policy_arn = aws_iam_policy.lambda_congito_basic_execution_policy.arn
}

# ==================== CLOUDWATCH LOG GROUPS for LAMBDAS ====================

# CloudWatch log group for cognito-code-template
resource "aws_cloudwatch_log_group" "cognito_code_template" {
  name              = "/aws/lambda/${aws_lambda_function.cognito_code_template.function_name}"
  log_group_class   = "STANDARD"
  retention_in_days = 0   # 0 is "Never expire"
}



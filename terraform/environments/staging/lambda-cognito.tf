# ==================== cognito-code-template LAMBDA ====================

# Lambda function cognito-code-template for cognito consumer && cor_item
resource "aws_lambda_function" "cognito_code_template" {
  filename        = data.archive_file.cognito_code_template_zip.output_path
  function_name   = var.cognito_code_template
  role            = aws_iam_role.lambda_congito_consumer_role.arn
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


# ==================== DefineAuthChallenge LAMBDA ====================

# Lambda function DefineAuthChallenge for consumer cognito
resource "aws_lambda_function" "define_auth_challenge" {
  filename        = data.archive_file.define_auth_challenge_zip.output_path
  function_name   = var.define_auth_challenge
  role            = aws_iam_role.lambda_congito_consumer_role.arn
  handler         = "index.handler"
  runtime         = "nodejs20.x"
  timeout         = 3
  memory_size     = 128
  
  layers = [var.lambda_insights_extension_layer_arn]

  source_code_hash = data.archive_file.define_auth_challenge_zip.output_base64sha256
}

# Create zip file from source code
data "archive_file" "define_auth_challenge_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/define_auth_challenge_lambda/index.mjs"
  output_path = "${path.module}/zip_code/define_auth_challenge_payload.zip"
}

# ==================== CreateAuthChallenge LAMBDA ====================

# Lambda function CreateAuthChallenge for consumer cognito
resource "aws_lambda_function" "create_auth_challenge" {
  filename        = data.archive_file.create_auth_challenge_zip.output_path
  function_name   = var.create_auth_challenge
  role            = aws_iam_role.lambda_congito_consumer_role.arn
  handler         = "index.handler"
  runtime         = "nodejs20.x"
  timeout         = 3
  memory_size     = 128
  
  layers = [var.lambda_insights_extension_layer_arn]

  source_code_hash = data.archive_file.create_auth_challenge_zip.output_base64sha256
}

# Create zip file from source code
data "archive_file" "create_auth_challenge_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/create_auth_challenge_lambda/index.mjs"
  output_path = "${path.module}/zip_code/create_auth_challenge_payload.zip"
}

# ==================== VerifyAuthChallengeResponse LAMBDA ====================

# Lambda function VerifyAuthChallengeResponse for consumer cognito
resource "aws_lambda_function" "verify_auth_challenge_response" {
  filename        = data.archive_file.verify_auth_challenge_response_zip.output_path
  function_name   = var.verify_auth_challenge_response
  role            = aws_iam_role.lambda_congito_consumer_role.arn
  handler         = "index.handler"
  runtime         = "nodejs20.x"
  timeout         = 3
  memory_size     = 128

  source_code_hash = data.archive_file.verify_auth_challenge_response_zip.output_base64sha256
}

# Create zip file from source code
data "archive_file" "verify_auth_challenge_response_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/verify_auth_challenge_response/index.mjs"
  output_path = "${path.module}/zip_code/verify_auth_challenge_response_payload.zip"
}

# ==================== SHARED LAMBDA IAM RESOURCES ====================

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_congito_consumer_role" {
  name = var.lambda_congito_consumer_role
  path = var.lambda_cognito_iam_resources_path

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
resource "aws_iam_policy" "lambda_congito_consumer_basic_execution_policy" {
  name = var.lambda_congito_consumer_basic_execution_policy
  path = var.lambda_cognito_iam_resources_path
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:eu-west-1:${var.aws_account_id}:*"
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

resource "aws_iam_policy" "lambda_congito_consumer_tracer_access_execution_policy" {
  name = var.lambda_congito_consumer_tracer_access_execution_policy
  path = var.lambda_cognito_iam_resources_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM policiy Attachments for cognito lambda
resource "aws_iam_role_policy_attachment" "lambda_congito_consumer_cloudwatch_lambda_insights_execution_policy" {
  role       = aws_iam_role.lambda_congito_consumer_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "lambda_congito_consumer_basic_execution_policy" {
  role       = aws_iam_role.lambda_congito_consumer_role.name
  policy_arn = aws_iam_policy.lambda_congito_consumer_basic_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_congito_consumer_tracer_access_execution_policy" {
  role       = aws_iam_role.lambda_congito_consumer_role.name
  policy_arn = aws_iam_policy.lambda_congito_consumer_tracer_access_execution_policy.arn
}


# ==================== CLOUDWATCH LOG GROUPS for LAMBDAS ====================

# CloudWatch log group for cognito-code-template
resource "aws_cloudwatch_log_group" "cognito_code_template" {
  name              = "/aws/lambda/${aws_lambda_function.cognito_code_template.function_name}"
  log_group_class   = "STANDARD"
  retention_in_days = 0   # 0 is "Never expire"
}

# CloudWatch log group for DefineAuthChallenge
resource "aws_cloudwatch_log_group" "define_auth_challenge" {
  name              = "/aws/lambda/${aws_lambda_function.define_auth_challenge.function_name}"
  log_group_class   = "STANDARD"
  retention_in_days = 0   # 0 is "Never expire"
}

# CloudWatch log group for CreateAuthChallenge
resource "aws_cloudwatch_log_group" "create_auth_challenge" {
  name              = "/aws/lambda/${aws_lambda_function.create_auth_challenge.function_name}"
  log_group_class   = "STANDARD"
  retention_in_days = 0   # 0 is "Never expire"
}

# CloudWatch log group for VerifyAuthChallengeResponse
resource "aws_cloudwatch_log_group" "verify_auth_challenge_response" {
  name              = "/aws/lambda/${aws_lambda_function.verify_auth_challenge_response.function_name}"
  log_group_class   = "STANDARD"
  retention_in_days = 0   # 0 is "Never expire"
}

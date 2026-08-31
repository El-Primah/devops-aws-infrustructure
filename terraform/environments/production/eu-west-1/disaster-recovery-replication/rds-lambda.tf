# ==================== CREATE SNAPSHOT LAMBDA ====================

# Lambda function for creating RDS snapshot
resource "aws_lambda_function" "create_snapshot" {
  filename        = data.archive_file.create_snapshot_zip.output_path
  function_name   = "${var.environment}-${var.lambda_create_snapshot}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "create_snapshot_lambda.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.create_snapshot_zip.output_base64sha256

  tags = {
    Name        = var.lambda_create_snapshot
    Environment = var.environment
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "create_snapshot_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/create_snapshot_lambda.py"
  output_path = "${path.module}/zip_code/create_snapshot_payload.zip"
}

# ==================== SHARE SNAPSHOT LAMBDA ====================

# Lambda function for sharing RDS snapshot
resource "aws_lambda_function" "share_snapshot" {
  filename        = data.archive_file.share_snapshot_zip.output_path
  function_name   = "${var.environment}-${var.lambda_share_snapshot}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "share_snapshot_lambda.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.share_snapshot_zip.output_base64sha256

  tags = {
    Name        = var.lambda_share_snapshot
    Environment = var.environment
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "share_snapshot_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/share_snapshot_lambda.py"
  output_path = "${path.module}/zip_code/share_snapshot_payload.zip"
}

# ==================== DELETE SNAPSHOT LAMBDA ====================

# Lambda function for deleting old RDS snapshots
resource "aws_lambda_function" "delete_snapshot" {
  filename        = data.archive_file.delete_snapshot_zip.output_path
  function_name   = "${var.environment}-${var.lambda_delete_snapshot}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "delete_snapshot_lambda.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.delete_snapshot_zip.output_base64sha256

  tags = {
    Name        = var.lambda_delete_snapshot
    Environment = var.environment
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "delete_snapshot_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/delete_snapshot_lambda.py"
  output_path = "${path.module}/zip_code/delete_snapshot_payload.zip"
}


# ==================== COPY SNAPSHOT LAMBDA ====================

# Lambda function for copying RDS snapshot
resource "aws_lambda_function" "copy_snapshot" {
  filename        = data.archive_file.copy_snapshot_zip.output_path
  function_name   = "${var.environment}-${var.lambda_copy_snapshot}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "copy_snapshot_lambda.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.copy_snapshot_zip.output_base64sha256

  tags = {
    Name        = var.lambda_copy_snapshot
    Environment = var.environment
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "copy_snapshot_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/copy_snapshot_lambda.py"
  output_path = "${path.module}/zip_code/copy_snapshot_lambda.zip"
}


# ==================== GET SNAPSHOT STATUS LAMBDA ====================

# Lambda function to get snapshot status in specific region
resource "aws_lambda_function" "get_snapshot_status" {
  filename        = data.archive_file.get_snapshot_status_zip.output_path
  function_name   = "${var.environment}-${var.lambda_get_snapshot_status}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "get_snapshot_status.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.get_snapshot_status_zip.output_base64sha256

  tags = {
    Name        = var.lambda_get_snapshot_status
    Environment = var.environment
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "get_snapshot_status_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/get_snapshot_status.py"
  output_path = "${path.module}/zip_code/get_snapshot_status.zip"
}


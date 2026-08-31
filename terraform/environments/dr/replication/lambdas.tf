# ==================== COPY SNAPSHOT LAMBDA ====================
# Lambda function for copying shared RDS snapshot
resource "aws_lambda_function" "copy_snapshot" {
  filename        = data.archive_file.lambda_zip.output_path
  function_name   = var.lambda_copy_snapshot
  role            = aws_iam_role.lambda_role.arn
  handler         = "copy_snapshot_lambda.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Name        = "dr-copy-shared-snapshot"
    Environment = "dr"
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/copy_snapshot_lambda.py"
  output_path = "${path.module}/zip_code/copy_snapshot_payload.zip"
}

# ==================== DELETE OLD SNAPSHOTS LAMBDA ====================
# Lambda function for deleting old RDS snapshots
resource "aws_lambda_function" "delete_snapshots" {
  filename        = data.archive_file.delete_snapshots_zip.output_path
  function_name   = var.lambda_delete_snapshots
  role            = aws_iam_role.lambda_role.arn
  handler         = "delete_snapshots_lambda.lambda_handler"
  runtime         = "python3.12"
  timeout         = 300
  memory_size     = 128

  source_code_hash = data.archive_file.delete_snapshots_zip.output_base64sha256

  tags = {
    Name        = "dr-delete-snapshots"
    Environment = "dr"
    Service     = "rds-snapshot"
  }
}

# Create zip file from source code
data "archive_file" "delete_snapshots_zip" {
  type        = "zip"
  source_file = "${path.module}/lambdas/delete_snapshots_lambda.py"
  output_path = "${path.module}/zip_code/delete_snapshots_payload.zip"
}

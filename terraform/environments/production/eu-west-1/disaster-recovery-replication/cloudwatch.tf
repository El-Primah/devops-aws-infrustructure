# CloudWatch log group for create snapshot Lambda
resource "aws_cloudwatch_log_group" "create_snapshot_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.create_snapshot.function_name}"
  retention_in_days = 14

  tags = {
    Environment = var.environment
  }
}

# CloudWatch log group for share snapshot Lambda
resource "aws_cloudwatch_log_group" "share_snapshot_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.share_snapshot.function_name}"
  retention_in_days = 14

  tags = {
    Environment = var.environment
  }
}

# CloudWatch log group for delete snapshot Lambda
resource "aws_cloudwatch_log_group" "delete_snapshot_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.delete_snapshot.function_name}"
  retention_in_days = 14

  tags = {
    Environment = var.environment
  }
}

# CloudWatch log group for copy snapshot Lambda
resource "aws_cloudwatch_log_group" "copy_snapshot_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.copy_snapshot.function_name}"
  retention_in_days = 14

  tags = {
    Environment = var.environment
  }
}

# CloudWatch log group for get snapshot status Lambda
resource "aws_cloudwatch_log_group" "get_snapshot_status_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.get_snapshot_status.function_name}"
  retention_in_days = 14

  tags = {
    Environment = var.environment
  }
}

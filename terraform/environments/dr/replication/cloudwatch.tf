# CloudWatch log groups
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.copy_snapshot.function_name}"
  retention_in_days = 14

  tags = {
    Environment = "dr"
  }
}

resource "aws_cloudwatch_log_group" "delete_snapshots_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.delete_snapshots.function_name}"
  retention_in_days = 14

  tags = {
    Environment = "dr"
  }
}

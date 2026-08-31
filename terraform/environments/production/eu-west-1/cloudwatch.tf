resource "aws_cloudwatch_log_group" "volume_monitor" {
  name              = "/aws/lambda/${aws_lambda_function.volume_monitor.function_name}"
  log_group_class   = "STANDARD"
  retention_in_days = 0   # 0 is "Never expire"
}

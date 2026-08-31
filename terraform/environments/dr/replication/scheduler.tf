
# EventBridge Scheduler Schedule
resource "aws_scheduler_schedule" "daily_stepfunction" {
  name                         = var.schedule_name
  description                  = "Trigger Step Machine daily at 04:00 GMT+2"
  schedule_expression          = "cron(0 2 * * ? *)"  # 02:00 UTC = 04:00 GMT+2
  state                        = "ENABLED"
  group_name                   = "default"
  
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_sfn_state_machine.rds_lambda_state_machine.arn
    role_arn = aws_iam_role.scheduler_role.arn
  }
}

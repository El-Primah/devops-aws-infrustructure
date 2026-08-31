# ======================= Lambda function k8s-run-command =========================
variable "k8s_run_command_path_to_files" {
  default = "lambdas/k8s-run-command"
}

resource "aws_lambda_function" "k8s_run_command" {
  function_name    = "k8s-run-command"

  filename         = "${path.module}/${var.k8s_run_command_path_to_files}/lambda_function.zip"
  role             = aws_iam_role.Production_Run_Platform_API_Command_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 63
  memory_size      = 128
  vpc_config {
    security_group_ids = [module.vpc.security_groups["lambdaAll"].id]
    
    subnet_ids = [
      module.vpc.subnets["y_app_private_eu_west_1c"].id,
      module.vpc.subnets["eu_west_1a"].id,
      module.vpc.subnets["eu_west_1c"].id,
      module.vpc.subnets["y_app_private_eu_west_1a"].id,
      module.vpc.subnets["y_app_private_eu_west_1b"].id
    ]
    ipv6_allowed_for_dual_stack = false
  }

  source_code_hash = filebase64sha256("${path.module}/${var.k8s_run_command_path_to_files}/lambda_function.zip")
  depends_on = [data.external.build_lambda_k8s_run_command]
}

data "external" "build_lambda_k8s_run_command" {
  program = [
    "bash", "-c",
    <<EOT
      cd ${path.module}/${var.k8s_run_command_path_to_files} &&
      rm -rf build/ &&
      mkdir -p build/ &&
      pip install --no-cache-dir -r requirements.txt --target ./build/ >/dev/null 2>&1 &&
      cp lambda_function.py build/ &&
      find build/ -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true &&
      find build/ -name '*.pyc' -type f -exec rm -f {} + 2>/dev/null || true &&
      find build/ -exec touch -d '2025-01-01 00:00:00' {} + &&
      cd build && zip -X -FS -r ../lambda_function.zip . >/dev/null 2>&1 &&
      echo '{"status":"done"}'
    EOT
  ]

  query = {
    requirements_hash = filemd5("${path.module}/${var.k8s_run_command_path_to_files}/requirements.txt")
    script_hash       = filemd5("${path.module}/${var.k8s_run_command_path_to_files}/lambda_function.py")
  }
}


# ======================= Lambda function volume_monitor =========================
variable "volume_monitor_path_to_files" {
  default = "lambdas/volume-monitor"
}

resource "aws_lambda_function" "volume_monitor" {
  filename         = "${path.module}/${var.volume_monitor_path_to_files}/lambda_function.zip"
  function_name    = "volume_monitor"
  role             = aws_iam_role.lambda_volume_monitor.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 60
  memory_size      = 128
  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "PassThrough"
  }
  environment {
    variables = {
      "POWER_AUTOMATE_WEBHOOK_URL" = "https://prod-98.westeurope.logic.azure.com:443/workflows/aea22681154a44dba6ad0af233730b3e/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=jWgZauItau7wM_zOMIn6JxYC78fwr2shI2JIQTtDBf0"
    }
  }
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/volume_monitor"
  }

  source_code_hash = filebase64sha256("${path.module}/${var.volume_monitor_path_to_files}/lambda_function.zip")
  depends_on = [data.external.build_lambda_volume_monitor]
}

data "external" "build_lambda_volume_monitor" {
  program = [
    "bash", "-c",
    <<EOT
      cd ${path.module}/${var.volume_monitor_path_to_files} &&
      rm -rf build/ &&
      mkdir -p build/ &&
      pip install --no-cache-dir -r requirements.txt --target ./build/ >/dev/null 2>&1 &&
      cp lambda_function.py build/ &&
      find build/ -name '__pycache__' -type d -exec rm -rf {} + 2>/dev/null || true &&
      find build/ -name '*.pyc' -type f -exec rm -f {} + 2>/dev/null || true &&
      find build/ -exec touch -d '2025-01-01 00:00:00' {} + &&
      cd build && zip -X -FS -r ../lambda_function.zip . >/dev/null 2>&1 &&
      echo '{"status":"done"}'
    EOT
  ]

  query = {
    requirements_hash = filemd5("${path.module}/${var.volume_monitor_path_to_files}/requirements.txt")
    script_hash       = filemd5("${path.module}/${var.volume_monitor_path_to_files}/lambda_function.py")
  }
}

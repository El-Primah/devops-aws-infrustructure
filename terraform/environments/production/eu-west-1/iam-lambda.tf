# IAM Lambda Roles
resource "aws_iam_role" "Production_Run_Platform_API_Command_role" {
  name = "Production-Run-Platform-API-Command-role-5p6gj880"
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

resource "aws_iam_role" "lambda_volume_monitor" {
  name = "volume_monitor-role-pelp9512"
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

# IAM Inline policies
resource "aws_iam_role_policy" "EKSReadAccess_for_lambda_k8s_run_command" {
  name = "EKSReadAccess"
  role = aws_iam_role.Production_Run_Platform_API_Command_role.name
  policy = jsonencode(
    {
      "Version": "2012-10-17"
      "Statement": [
        {
          "Sid": "EKSReadAccess",
          "Effect": "Allow",
          "Action": [
            "eks:ListClusters",
            "eks:DescribeCluster"
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "DescribeVolumes_for_lambda_volume_monitor" {
  name = "DescribeVolumes"
  role = aws_iam_role.lambda_volume_monitor.name
  policy = jsonencode(
    {
      "Version": "2012-10-17"
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeVolumes",
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

# IAM Lambda Policies
resource "aws_iam_policy" "AWSLambdaBasicExecutionRole_2b902019_8188_4283_88de_718af8027f15" {
  name = "AWSLambdaBasicExecutionRole-2b902019-8188-4283-88de-718af8027f15"
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
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/Production-Run-Platform-API-Command:*"
      }
    ]
  })
}

resource "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole_cefd11a0_c52d_4ff5_a1f7_17623ad12c19" {
  name = "AWSLambdaVPCAccessExecutionRole-cefd11a0-c52d-4ff5-a1f7-17623ad12c19"
  path = var.service_role_iam_resources_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeNetworkInterfaces"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole_960f92c1_e1c7_4f81_b203_0693ef9c38a6" {
  name = "AWSLambdaBasicExecutionRole-960f92c1-e1c7-4f81-b203-0693ef9c38a6"
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
        Resource = "${aws_cloudwatch_log_group.volume_monitor.arn}:*"
      }
    ]
  })
}

# IAM Lambda policy Attachments
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_2b902019_8188_4283_88de_718af8027f15" {
  role       = aws_iam_role.Production_Run_Platform_API_Command_role.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole_2b902019_8188_4283_88de_718af8027f15.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole_cefd11a0_c52d_4ff5_a1f7_17623ad12c19" {
  role       = aws_iam_role.Production_Run_Platform_API_Command_role.name
  policy_arn = aws_iam_policy.AWSLambdaVPCAccessExecutionRole_cefd11a0_c52d_4ff5_a1f7_17623ad12c19.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_960f92c1_e1c7_4f81_b203_0693ef9c38a6" {
  role       = aws_iam_role.lambda_volume_monitor.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole_960f92c1_e1c7_4f81_b203_0693ef9c38a6.arn
}


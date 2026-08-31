resource "aws_iam_role" "rds_lambda_state_machine_role" {
  name        = var.rds_lambda_state_machine_role
  description = "Role for State machine rds-copy-delete"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "states.amazonaws.com"
          }
        },
      ]
      Version   = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "AWSLambdaRole" {
  role = aws_iam_role.rds_lambda_state_machine_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

resource "aws_iam_role_policy" "rds_lambda_state_machine_role_policy" {
  name = var.rds_lambda_state_machine_role_policy
  role = aws_iam_role.rds_lambda_state_machine_role.id
  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
                        "rds:DescribeDBInstances",
                        "rds:DescribeDBSnapshots",
                        "rds:DescribeDBSnapshotAttributes"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ],
      "Version": "2012-10-17"
    }
  )
}

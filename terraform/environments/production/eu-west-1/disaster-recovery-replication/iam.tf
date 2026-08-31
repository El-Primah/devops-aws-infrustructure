# IAM role for Lambda functions
resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-${var.lambda_role_name}"

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

  tags = {
    Name = "${var.environment}-rds-snapshot-lambda-role"
  }
}

# IAM policy for Lambda functions
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.environment}-${var.lambda_policy_name}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:CreateDBSnapshot",
          "rds:DescribeDBSnapshots",
          "rds:DeleteDBSnapshot",
          "rds:ModifyDBSnapshotAttribute",
          "rds:DescribeDBSnapshotAttributes",
          "rds:AddTagsToResource",
          "rds:CopyDBSnapshot"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:generateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = [
          "arn:aws:kms:eu-west-1:${data.aws_caller_identity.current.account_id}:key/5549b912-62bb-4813-a38a-9765db8d5581",
          "arn:aws:kms:eu-central-1:${data.aws_caller_identity.current.account_id}:key/58f9bf34-3f1c-4141-9889-e770cbea5b1a",
          "arn:aws:kms:eu-west-1:${data.aws_caller_identity.current.account_id}:alias/rds/prod"
        ]
      }
    ]
  })
}


#Scheduler
resource "aws_iam_role" "scheduler_role" {
  name = var.scheduler_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "stepfunction_execution_policy" {
  name = "StateMachineForSnapshots-SchedulerPolicy"
  role = aws_iam_role.scheduler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = aws_sfn_state_machine.rds_lambda_state_machine.arn
      }
    ]
  })
}

#STATE MACHINE
resource "aws_iam_role" "rds_lambda_state_machine_role" {
  name        = var.rds_lambda_state_machine_role
  description = "Role for State machine rds-copy-share"
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

# -- comp-genomic-documents-eu replication IAM --
resource "aws_iam_role" "genomic_docs_replication" {
  name = "genomic-docs-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "genomic_docs_replication" {
  name = "genomic-docs-replication"
  role = aws_iam_role.genomic_docs_replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = [
          "arn:aws:s3:::${local.genomic_docs_id}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration"
        ]
        Resource = [
          "arn:aws:s3:::${local.genomic_docs_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          "${var.genomic_docs_dr_arn}/*"
        ]
      }
    ]
  })
}

# -- comp-user-bl_item-production replication IAM --
resource "aws_iam_role" "user_bl_item_replication" {
  name = "user-bl_item-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "user_bl_item_replication" {
  name = "user-bl_item-replication"
  role = aws_iam_role.user_bl_item_replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectVersionForReplication"
        ]
        Resource = [
          "arn:aws:s3:::${local.user_bl_item_id}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:*"
        ]
        Resource = [ "*" ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration"
        ]
        Resource = [
          "arn:aws:s3:::${local.user_bl_item_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          "${var.user_bl_item_dr_arn}/*"
        ]
      }
    ]
  })
}

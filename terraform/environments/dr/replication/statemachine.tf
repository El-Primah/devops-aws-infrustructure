resource "aws_sfn_state_machine" "rds_lambda_state_machine" {
  name     = var.rds_lambda_state_machine_name
  role_arn = aws_iam_role.rds_lambda_state_machine_role.arn

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Copy Snapshot",
  "States": {
    "Copy Snapshot": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "${aws_lambda_function.copy_snapshot.arn}:$LATEST",
        "Payload": "{% $states.input %}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 1,
          "MaxAttempts": 3,
          "BackoffRate": 2,
          "JitterStrategy": "FULL"
        }
      ],
      "Next": "Wait for snapshot to copy",
      "Assign": {
        "SnapshotID": "{% $states.result.Payload.body.copied_snapshot_id %}"
      }
    },
    "Wait for snapshot to copy": {
      "Type": "Wait",
      "Seconds": 30,
      "Next": "Get snapshot status"
    },
    "Get snapshot status": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:rds:describeDBSnapshots",
      "Next": "Check if snapshot is available",
      "Assign": {
        "SnapshotStatus": "{% $states.result.DbSnapshots[0].Status %}"
      },
      "Arguments": {
        "DbSnapshotIdentifier": "{% $SnapshotID %}"
      }
    },
    "Check if snapshot is available": {
      "Type": "Choice",
      "Choices": [
        {
          "Next": "Delete Snapshot",
          "Condition": "{% ($SnapshotStatus) = (\"available\") %}"
        }
      ],
      "Default": "Wait for snapshot to copy"
    },
    "Delete Snapshot": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "${aws_lambda_function.delete_snapshots.arn}:$LATEST",
        "Payload": {
          "db_instance_identifier": "${var.rds_instance_name_for_snapshot_lambda}"
        }
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 1,
          "MaxAttempts": 3,
          "BackoffRate": 2,
          "JitterStrategy": "FULL"
        }
      ],
      "End": true
    }
  },
  "QueryLanguage": "JSONata"
}
EOF
}

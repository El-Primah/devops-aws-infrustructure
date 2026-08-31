resource "aws_sfn_state_machine" "rds_lambda_state_machine" {
  name     = var.rds_lambda_state_machine_name
  role_arn = aws_iam_role.rds_lambda_state_machine_role.arn

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Create Snapshot",
  "States": {
    "Create Snapshot": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:eu-west-1:939393939393:function:prod-create-rds-snapshot:$LATEST",
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
      "Next": "Wait for snapshot to create",
      "Assign": {
        "OriginalSnapshotID": "{% $states.result.Payload.body.snapshot_id %}",
        "RDS_instanceID": "{% $states.result.Payload.body.db_instance_id %}"
      }
    },
    "Wait for snapshot to create": {
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
        "DbSnapshotIdentifier": "{% $OriginalSnapshotID %}"
      }
    },
    "Check if snapshot is available": {
      "Type": "Choice",
      "Choices": [
        {
          "Next": "Copy Snapshot to Frankfurt",
          "Condition": "{% ($SnapshotStatus) = (\"available\") %}"
        }
      ],
      "Default": "Wait for snapshot to create"
    },
    "Copy Snapshot to Frankfurt": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:eu-west-1:939393939393:function:prod-copy-rds-snapshot:$LATEST",
        "Payload": {
          "ID_SNAPSHOT_TO_COPY": "{% $OriginalSnapshotID %}"
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
      "Next": "Wait for snapshot in Frankfurt to create",
      "Assign": {
        "SnapshotID_To_Share": "{% $states.result.Payload.body.copied_snapshot_id %}"
      }
    },
    "Wait for snapshot in Frankfurt to create": {
      "Type": "Wait",
      "Seconds": 30,
      "Next": "Get status of snapshot in Frankfurt"
    },
    "Get status of snapshot in Frankfurt": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:eu-west-1:939393939393:function:prod-get-rds-snapshot-status:$LATEST",
        "Payload": {
          "SnapshotID_To_Check": "{% $SnapshotID_To_Share %}"
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
      "Next": "Check if snapshot in Frankfurt is available",
      "Assign": {
        "snapshot_status": "{% $states.result.Payload.body.snapshot_status %}"
      }
    },
    "Check if snapshot in Frankfurt is available": {
      "Type": "Choice",
      "Choices": [
        {
          "Next": "Share Snapshot",
          "Condition": "{% ($snapshot_status) = (\"available\") %}"
        }
      ],
      "Default": "Wait for snapshot in Frankfurt to create"
    },
    "Share Snapshot": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:eu-west-1:939393939393:function:prod-share-rds-snapshot:$LATEST",
        "Payload": {
          "ID_SNAPSHOT_TO_SHARE": "{% $SnapshotID_To_Share %}"
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
      "Next": "Delete Snapshot"
    },
    "Delete Snapshot": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:eu-west-1:939393939393:function:prod-delete-rds-snapshot:$LATEST",
        "Payload": {
          "db_instance_identifier": "{% $RDS_instanceID %}"
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


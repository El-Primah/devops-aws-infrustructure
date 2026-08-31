import boto3
import logging
import os
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default configuration
DEFAULT_CHECK_REGION = "eu-central-1"

def lambda_handler(event, context):
    """
    Lambda function to check the status of an RDS snapshot in eu-central-1.
    If the status cannot be retrieved, the function raises an exception.
    """
    # Get configuration from environment variables or use defaults
    check_region = os.environ.get('CHECK_REGION', DEFAULT_CHECK_REGION)

    # Expect the snapshot ID (in eu-central-1) from the event
    snapshot_id = event.get('SnapshotID_To_Check')

    if not snapshot_id:
        logger.error("snapshot_id_to_check (or copied_snapshot_id) is not provided in event")
        # Raise an exception for missing input
        raise ValueError("snapshot_id_to_check (or copied_snapshot_id) is required in event")

    logger.info(f"Configuration: Check Region={check_region}")
    logger.info(f"Snapshot ID to check: {snapshot_id}")

    # Client for the region where the snapshot is located (eu-central-1)
    rds_check_client = boto3.client('rds', region_name=check_region)

    try:
        logger.info(f"Describing snapshot '{snapshot_id}' in {check_region}...")
        response = rds_check_client.describe_db_snapshots(
            DBSnapshotIdentifier=snapshot_id
        )

        if not response['DBSnapshots']:
            # If the snapshot is not found, this is also an error condition for the check
            error_message = f"Snapshot '{snapshot_id}' not found in {check_region}"
            logger.error(error_message)
            # Raise an exception if the snapshot does not exist
            raise Exception(error_message)

        snapshot = response['DBSnapshots'][0]
        snapshot_status = snapshot['Status']
        snapshot_arn = snapshot.get('DBSnapshotArn', 'N/A')

        logger.info(f"Snapshot '{snapshot_id}' status in {check_region}: {snapshot_status}")

        # Return the status, the calling State Machine step will handle the logic based on this value
        return {
            'statusCode': 200,
            'body': {
                'message': 'Snapshot status retrieved',
                'snapshot_id': snapshot_id,
                'snapshot_arn': snapshot_arn,
                'snapshot_status': snapshot_status,
                'region': check_region,
                'status': 'retrieved'
            }
        }

    except ClientError as e:
        # Log the AWS service error
        error_code = e.response['Error']['Code']
        error_message = e.response['Error']['Message']
        logger.error(f"AWS ClientError checking snapshot status in {check_region}: {error_code} - {error_message}")
        # Re-raise the exception to signal failure to Step Functions
        raise e

    except Exception as e:
        # Log any other unexpected error
        logger.error(f"Unexpected error checking snapshot status in {check_region}: {str(e)}")
        # Re-raise the exception to signal failure to Step Functions
        raise e


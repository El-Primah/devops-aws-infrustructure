# prod-copy-snapshot-to-central-1.py

import boto3
import logging
import os
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default configuration
DEFAULT_PROD_REGION = "eu-west-1"  # Region where the source snapshot is located
DEFAULT_DR_REGION = "eu-central-1" # Region to copy the snapshot to
KMS_KEY_FOR_SNAPSHOTS = "alias/RDS-snapshot-KMS"

def lambda_handler(event, context):
    """
    Lambda function to initiate copying an RDS snapshot from PROD region (eu-west-1) 
    to DR region (eu-central-1) within the same account. This function does not wait 
    for the copy to complete.
    """
    # Get configuration from environment variables or use defaults
    prod_region = os.environ.get('PROD_REGION', DEFAULT_PROD_REGION)
    dr_region = os.environ.get('DR_REGION', DEFAULT_DR_REGION)

    # Expect the source snapshot ID (in eu-west-1) from the event
    snapshot_id = event.get('ID_SNAPSHOT_TO_COPY') or event.get('ID_SNAPSHOT_TO_SHARE')

    if not snapshot_id:
        logger.error("ID_SNAPSHOT_TO_COPY (or ID_SNAPSHOT_TO_SHARE) is not provided in event")
        return {
            'statusCode': 400,
            'body': {
                'message': 'ID_SNAPSHOT_TO_COPY (or ID_SNAPSHOT_TO_SHARE) is required in event',
                'status': 'error'
            }
        }

    logger.info(f"Configuration: Source Region={prod_region}, Target DR Region={dr_region}")
    logger.info(f"Source Snapshot ID to copy: {snapshot_id}")

    # Clients for both regions
    rds_prod_client = boto3.client('rds', region_name=prod_region)
    rds_dr_client = boto3.client('rds', region_name=dr_region)

    # 1. Get ARN of the source snapshot and verify its status in the source region
    try:
        logger.info(f"Getting details for source snapshot '{snapshot_id}' in {prod_region}...")
        response = rds_prod_client.describe_db_snapshots(
            DBSnapshotIdentifier=snapshot_id
        )
        source_snapshot = response['DBSnapshots'][0]
        source_snapshot_arn = source_snapshot['DBSnapshotArn']
        status = source_snapshot['Status']
        logger.info(f"Source snapshot ARN: {source_snapshot_arn}, Status: {status}")

        if status != 'available':
            logger.error(f"Source snapshot '{snapshot_id}' is not available, current status: {status}")
            return {
                'statusCode': 500,
                'body': {
                    'message': f"Source snapshot '{snapshot_id}' is not available, status: {status}",
                    'status': 'error'
                }
            }
    except ClientError as e:
        logger.error(f"Error describing source snapshot in {prod_region}: {e}")
        return {
            'statusCode': 500,
            'body': {
                'message': f"Error describing source snapshot: {e}",
                'status': 'error'
            }
        }

    # 2. generate name for the new snapshot in the DR region
    dr_snapshot_id = f"central-{snapshot_id}"

    # 3. Initiate copying the snapshot within the account from prod_region to dr_region
    try:
        logger.info(f"Starting copy of snapshot '{snapshot_id}' from {prod_region} to {dr_region} as '{dr_snapshot_id}'...")
        copy_response = rds_dr_client.copy_db_snapshot(
            SourceDBSnapshotIdentifier=source_snapshot_arn, # ARN of the source snapshot
            TargetDBSnapshotIdentifier=dr_snapshot_id,
            SourceRegion=prod_region, # Specify the source region
            KmsKeyId=KMS_KEY_FOR_SNAPSHOTS
        )
        dr_snapshot_arn = copy_response['DBSnapshot']['DBSnapshotArn']
        logger.info(f"Copy initiated. New snapshot ARN in {dr_region}: {dr_snapshot_arn}")

        # Return immediately after initiating the copy
        return {
            'statusCode': 200,
            'body': {
                'message': 'Snapshot copy initiated',
                'original_snapshot_id': snapshot_id,
                'original_snapshot_arn': source_snapshot_arn,
                'copied_snapshot_id': dr_snapshot_id, # ID of the snapshot being copied to eu-central-1
                'copied_snapshot_arn': dr_snapshot_arn, # ARN of the snapshot being copied
                'dr_region': dr_region,
                'status': 'copy_initiated'
            }
        }

    except ClientError as e:
        logger.error(f"Error initiating copy to {dr_region}: {e}")
        return {
            'statusCode': 500,
            'body': {
                'message': f"Error initiating copy: {e}",
                'status': 'error'
            }
        }


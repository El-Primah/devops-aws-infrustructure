import boto3
import logging
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default configuration
DEFAULT_DR_REGION = "eu-central-1"
KMS_KEY_FOR_SNAPSHOTS = "alias/aws/rds"

def lambda_handler(event, context):
    """
    Lambda function to copy the latest shared RDS snapshot (does not wait for completion)
    """
    
    # Get configuration from environment variables or use defaults
    dr_region = os.environ.get('AWS_REGION', DEFAULT_DR_REGION)
    
    logger.info(f"Using region: {dr_region}")
    
    # Initialize RDS client
    rds_client = boto3.client('rds', region_name=dr_region)
    
    try:
        # Get all shared snapshots
        logger.info("Finding latest shared snapshot...")
        response = rds_client.describe_db_snapshots(
            SnapshotType='shared',
            IncludeShared=True
        )
        
        if not response['DBSnapshots']:
            raise Exception("No shared snapshots found")
        
        # Sort snapshots by creation time (newest first)
        snapshots = sorted(response['DBSnapshots'], key=lambda x: x['SnapshotCreateTime'], reverse=True)
        latest_shared_snapshot = snapshots[0]
        shared_snapshot_arn = latest_shared_snapshot['DBSnapshotArn']
        
        logger.info(f"Latest shared snapshot: {shared_snapshot_arn}")
        
        # Extract snapshot name from ARN
        shared_snapshot_arn_no_prefix = shared_snapshot_arn.split(':')[-1]
        copied_snapshot_id = f"dr-copy-of-{shared_snapshot_arn_no_prefix}"
        
        logger.info(f"Initiating copy of {shared_snapshot_arn_no_prefix} to {copied_snapshot_id}")
        
        # Start copying snapshot
        response = rds_client.copy_db_snapshot(
            SourceDBSnapshotIdentifier=shared_snapshot_arn,
            TargetDBSnapshotIdentifier=copied_snapshot_id,
            KmsKeyId=KMS_KEY_FOR_SNAPSHOTS
        )
        logger.info(f"Snapshot copy initiated: {copied_snapshot_id}")
        
        return {
            'statusCode': 200,
            'body': {
                'message': 'Snapshot copy initiated',
                'original_snapshot_arn': shared_snapshot_arn,
                'copied_snapshot_id': copied_snapshot_id,
                'status': 'initiated'
            }
        }
        
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': {
                'message': f'Error occurred: {str(e)}',
                'status': 'error'
            }
        }

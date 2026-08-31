import boto3
import logging
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default configuration
DEFAULT_SHARE_REGION = "eu-central-1"
DEFAULT_DR_ACCOUNT_ID = "101010101010"

def lambda_handler(event, context):
    """
    Lambda function to share the latest RDS snapshot with DR account
    """
    
    # Get configuration from environment variables or use defaults
    prod_region = os.environ.get('PROD_REGION', DEFAULT_SHARE_REGION)
    dr_account_id = os.environ.get('DR_ACCOUNT_ID', DEFAULT_DR_ACCOUNT_ID)
    
    # RD of PROD snapshot to share it to DR
    snapshot_id = event.get('ID_SNAPSHOT_TO_SHARE') 
    
    if not snapshot_id:
        logger.error("ID_SNAPSHOT_TO_SHARE is not provided in event")
        return {
            'statusCode': 400,
            'body': {
                'message': 'ID_SNAPSHOT_TO_SHARE is required in event',
                'status': 'error'
            }
        }
    
    logger.info(f"Configuration: Region={prod_region}, DR Account={dr_account_id}")
    logger.info(f"Snapshot ID to share: {snapshot_id}")
    
    rds_client = boto3.client('rds', region_name=prod_region)
    
    try:
        # Verify snapshot exists and get its details
        logger.info(f"Verifying snapshot '{snapshot_id}' exists...")
        try:
            response = rds_client.describe_db_snapshots(
                DBSnapshotIdentifier=snapshot_id
            )
            
            if not response['DBSnapshots']:
                raise Exception(f"Snapshot '{snapshot_id}' not found")
            
            snapshot = response['DBSnapshots'][0]
            snapshot_arn = snapshot['DBSnapshotArn']
            snapshot_type = snapshot.get('SnapshotType', 'unknown')
            
            logger.info(f"Snapshot found: {snapshot_id} (Type: {snapshot_type})")
            logger.info(f"Snapshot ARN: {snapshot_arn}")
            
        except rds_client.exceptions.DBSnapshotNotFoundFault:
            raise Exception(f"Snapshot '{snapshot_id}' not found")
        
        # Share snapshot with DR account
        logger.info(f"Sharing snapshot with DR account ({dr_account_id})...")
        rds_client.modify_db_snapshot_attribute(
            DBSnapshotIdentifier=snapshot_id,
            AttributeName='restore',
            ValuesToAdd=[dr_account_id]
        )
        logger.info(f"Snapshot shared successfully with DR account")
        
        # Verify sharing
        logger.info("Verifying snapshot permissions...")
        attributes = rds_client.describe_db_snapshot_attributes(DBSnapshotIdentifier=snapshot_id)
        restore_attributes = attributes['DBSnapshotAttributesResult']['DBSnapshotAttributes']
        
        shared_with = []
        for attr in restore_attributes:
            if attr['AttributeName'] == 'restore':
                shared_with = attr['AttributeValues']
                break
        
        if dr_account_id in shared_with:
            logger.info("DR account access confirmed")
        else:
            logger.warning("Could not verify DR account access (may be delayed)")
        
        return {
            'statusCode': 200,
            'body': {
                'message': 'Latest snapshot shared successfully',
                'snapshot_id': snapshot_id,
                'snapshot_arn': snapshot_arn,
                'dr_account_id': dr_account_id,
                'status': 'shared'
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


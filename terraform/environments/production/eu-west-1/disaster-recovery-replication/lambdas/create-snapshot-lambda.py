import boto3
import logging
import datetime
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default configuration
DEFAULT_PROD_DB_INSTANCE_ID = "prodmysql-y_app"
DEFAULT_PROD_REGION = "eu-west-1"

def lambda_handler(event, context):
    """
    Lambda function to create RDS snapshot (does not wait for completion)
    """
    
    # Get configuration from environment variables or use defaults
    prod_db_instance_id = os.environ.get('PROD_DB_INSTANCE_ID', DEFAULT_PROD_DB_INSTANCE_ID)
    prod_region = os.environ.get('PROD_REGION', DEFAULT_PROD_REGION)
    
    logger.info(f"Configuration: DB Instance={prod_db_instance_id}, Region={prod_region}")
    
    # Initialize RDS client
    rds_client = boto3.client('rds', region_name=prod_region)
    
    try:
        # Check if RDS instance exists
        logger.info(f"Checking if RDS instance '{prod_db_instance_id}' exists...")
        rds_client.describe_db_instances(DBInstanceIdentifier=prod_db_instance_id)
        logger.info("RDS instance exists")
        
        # generate snapshot identifier
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
        snapshot_id = f"shared-snapshot-{timestamp}"
        
        # Create snapshot
        logger.info(f"Creating snapshot '{snapshot_id}'...")
        rds_client.create_db_snapshot(
            DBInstanceIdentifier=prod_db_instance_id,
            DBSnapshotIdentifier=snapshot_id
        )
        logger.info(f"Snapshot '{snapshot_id}' creation initiated")
        
        # Get snapshot ARN
        response = rds_client.describe_db_snapshots(DBSnapshotIdentifier=snapshot_id)
        snapshot_arn = response['DBSnapshots'][0]['DBSnapshotArn']
        logger.info(f"Snapshot ARN: {snapshot_arn}")
        
        return {
            'statusCode': 200,
            'body': {
                'message': 'Snapshot creation initiated',
                'snapshot_id': snapshot_id,
                'snapshot_arn': snapshot_arn,
                'db_instance_id': DEFAULT_PROD_DB_INSTANCE_ID,
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

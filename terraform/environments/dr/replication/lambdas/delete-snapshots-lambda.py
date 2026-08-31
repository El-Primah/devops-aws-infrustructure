import boto3
import datetime
from datetime import timezone
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Get database instance identifier from event parameters
    db_instance_identifier = event.get('db_instance_identifier')
    snapshot_prefix = event.get('snapshot_prefix', 'dr-copy-of-')
    
    # Validate input parameter
    if not db_instance_identifier:
        logger.error("db_instance_identifier parameter is required")
        return {
            'statusCode': 400,
            'body': 'Error: db_instance_identifier parameter is required'
        }
    
    # Initialize RDS client
    rds_client = boto3.client('rds')
    
    # Calculate the date threshold (5 days ago)
    days_threshold = 5
    threshold_date = datetime.datetime.now(timezone.utc) - datetime.timedelta(days=days_threshold)
    
    logger.info(f"Starting cleanup for database: {db_instance_identifier}")
    logger.info(f"Looking for snapshots with prefix: {snapshot_prefix}")
    logger.info(f"Threshold date: {threshold_date}")
    
    try:
        # Get all manual snapshots for the specified DB instance
        response = rds_client.describe_db_snapshots(
            DBInstanceIdentifier=db_instance_identifier,
            SnapshotType='manual'
        )
        
        # List to store deleted snapshots
        deleted_snapshots = []
        
        # Check if snapshots exist
        if 'DBSnapshots' not in response or len(response['DBSnapshots']) == 0:
            logger.info(f"No manual snapshots found for database: {db_instance_identifier}")
            return {
                'statusCode': 200,
                'body': {
                    'message': f'No manual snapshots found for database {db_instance_identifier}',
                    'deleted_snapshots': [],
                    'deleted_count': 0
                }
            }
        
        logger.info(f"Found {len(response['DBSnapshots'])} manual snapshots")
        
        # Process each snapshot
        for snapshot in response['DBSnapshots']:
            snapshot_identifier = snapshot['DBSnapshotIdentifier']
            snapshot_create_time = snapshot['SnapshotCreateTime']
            
            if not snapshot_identifier.startswith(snapshot_prefix):
                logger.info(f"Skipping snapshot {snapshot_identifier} - doesn't match prefix '{snapshot_prefix}'")
                continue
            
            # Check if snapshot is older than threshold
            if snapshot_create_time < threshold_date:
                try:
                    logger.info(f"Deleting snapshot: {snapshot_identifier} (created: {snapshot_create_time})")
                    # Delete the old snapshot
                    rds_client.delete_db_snapshot(
                        DBSnapshotIdentifier=snapshot_identifier
                    )
                    deleted_snapshots.append(snapshot_identifier)
                    logger.info(f"Successfully deleted snapshot: {snapshot_identifier}")
                except Exception as delete_error:
                    logger.error(f"Error deleting snapshot {snapshot_identifier}: {str(delete_error)}")
            else:
                logger.info(f"Snapshot {snapshot_identifier} is newer than {days_threshold} days, skipping...")
        
        # Return success response
        logger.info(f"Cleanup completed. Deleted {len(deleted_snapshots)} snapshots")
        return {
            'statusCode': 200,
            'body': {
                'message': f'Successfully processed snapshots for database {db_instance_identifier}',
                'deleted_snapshots': deleted_snapshots,
                'deleted_count': len(deleted_snapshots)
            }
        }
        
    except Exception as e:
        # Handle any errors during execution
        error_message = f"Error processing RDS snapshots: {str(e)}"
        logger.error(error_message)
        return {
            'statusCode': 500,
            'body': error_message
        }


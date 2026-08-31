import boto3
import datetime
from datetime import timezone
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Default configuration
DEFAULT_PROD_REGION = "eu-west-1"
DEFAULT_DR_REGION = "eu-central-1" # The region where copied snapshots are stored

def lambda_handler(event, context):
    # Get database instance identifier from event parameters
    db_instance_identifier = event.get('db_instance_identifier')
    snapshot_prefix = event.get('snapshot_prefix', 'shared-snapshot') # Default prefix for snapshots in PROD region
    snapshot_prefix_central = event.get('snapshot_prefix_central', 'central-copy') # Default prefix for snapshots copied to DR region
    
    # Validate input parameter
    if not db_instance_identifier:
        logger.error("db_instance_identifier parameter is required")
        return {
            'statusCode': 400,
            'body': 'Error: db_instance_identifier parameter is required'
        }
    
    # Calculate the date threshold (5 days ago)
    days_threshold = 5
    threshold_date = datetime.datetime.now(timezone.utc) - datetime.timedelta(days=days_threshold)
    
    logger.info(f"Starting cleanup for database: {db_instance_identifier}")
    logger.info(f"Looking for snapshots with prefix: {snapshot_prefix} in {DEFAULT_PROD_REGION}")
    logger.info(f"Looking for snapshots with prefix: {snapshot_prefix_central} in {DEFAULT_DR_REGION}")
    logger.info(f"Threshold date: {threshold_date}")
    
    # Initialize RDS clients for both regions
    rds_prod_client = boto3.client('rds', region_name=DEFAULT_PROD_REGION)
    rds_dr_client = boto3.client('rds', region_name=DEFAULT_DR_REGION)
    
    all_deleted_snapshots = []
    total_deleted_count = 0

    # --- Process snapshots in eu-west-1 (PROD region) ---
    logger.info(f"Processing snapshots in {DEFAULT_PROD_REGION}...")
    try:
        # Get all manual snapshots for the specified DB instance in PROD region
        response = rds_prod_client.describe_db_snapshots(
            DBInstanceIdentifier=db_instance_identifier,
            SnapshotType='manual'
        )
        
        # Check if snapshots exist
        if 'DBSnapshots' not in response or len(response['DBSnapshots']) == 0:
            logger.info(f"No manual snapshots found for database: {db_instance_identifier} in {DEFAULT_PROD_REGION}")
        else:
            logger.info(f"Found {len(response['DBSnapshots'])} manual snapshots in {DEFAULT_PROD_REGION}")
            
            # Process each snapshot in PROD region
            for snapshot in response['DBSnapshots']:
                snapshot_identifier = snapshot['DBSnapshotIdentifier']
                snapshot_create_time = snapshot['SnapshotCreateTime']
                
                if not snapshot_identifier.startswith(snapshot_prefix):
                    logger.info(f"Skipping snapshot {snapshot_identifier} in {DEFAULT_PROD_REGION} - doesn't match prefix '{snapshot_prefix}'")
                    continue
                
                # Check if snapshot is older than threshold
                if snapshot_create_time < threshold_date:
                    try:
                        logger.info(f"Deleting snapshot: {snapshot_identifier} (created: {snapshot_create_time}) in {DEFAULT_PROD_REGION}")
                        # Delete the old snapshot
                        rds_prod_client.delete_db_snapshot(
                            DBSnapshotIdentifier=snapshot_identifier
                        )
                        all_deleted_snapshots.append(f"{DEFAULT_PROD_REGION}:{snapshot_identifier}")
                        logger.info(f"Successfully deleted snapshot: {snapshot_identifier} in {DEFAULT_PROD_REGION}")
                        total_deleted_count += 1
                    except Exception as delete_error:
                        logger.error(f"Error deleting snapshot {snapshot_identifier} in {DEFAULT_PROD_REGION}: {str(delete_error)}")
                else:
                    logger.info(f"Snapshot {snapshot_identifier} in {DEFAULT_PROD_REGION} is newer than {days_threshold} days, skipping...")
    
    except Exception as e:
        # Handle any errors during execution in PROD region
        error_message = f"Error processing RDS snapshots in {DEFAULT_PROD_REGION}: {str(e)}"
        logger.error(error_message)
        # Continue to DR region processing even if PROD fails
        # You might want to return early if this error is critical
        # return { 'statusCode': 500, 'body': error_message }

    # --- Process snapshots in eu-central-1 (DR region - for copied snapshots) ---
    # We need to find snapshots based on the copied prefix, not the original DB instance ID
    # Adjust the search criteria if needed. If the copied snapshots don't retain the original DBInstanceIdentifier,
    # we might need to search more broadly or use tags if available.
    # For now, assuming we search by the generated prefix.
    logger.info(f"Processing snapshots in {DEFAULT_DR_REGION}...")
    try:
        # Get all manual snapshots matching the central copy prefix
        response_dr = rds_dr_client.describe_db_snapshots(
            # DBInstanceIdentifier=db_instance_identifier, # This might not apply to copied snapshots
            SnapshotType='manual'
        )
        
        # Check if snapshots exist
        if 'DBSnapshots' not in response_dr or len(response_dr['DBSnapshots']) == 0:
            logger.info(f"No manual snapshots found in {DEFAULT_DR_REGION}")
        else:
            logger.info(f"Found {len(response_dr['DBSnapshots'])} manual snapshots in {DEFAULT_DR_REGION}")
            
            # Process each snapshot in DR region
            for snapshot in response_dr['DBSnapshots']:
                snapshot_identifier = snapshot['DBSnapshotIdentifier']
                snapshot_create_time = snapshot['SnapshotCreateTime']
                
                # Check if the snapshot name starts with the central copy prefix
                if not snapshot_identifier.startswith(snapshot_prefix_central):
                    logger.info(f"Skipping snapshot {snapshot_identifier} in {DEFAULT_DR_REGION} - doesn't match prefix '{snapshot_prefix_central}'")
                    continue
                
                # Check if snapshot is older than threshold
                if snapshot_create_time < threshold_date:
                    try:
                        logger.info(f"Deleting snapshot: {snapshot_identifier} (created: {snapshot_create_time}) in {DEFAULT_DR_REGION}")
                        # Delete the old snapshot
                        rds_dr_client.delete_db_snapshot(
                            DBSnapshotIdentifier=snapshot_identifier
                        )
                        all_deleted_snapshots.append(f"{DEFAULT_DR_REGION}:{snapshot_identifier}")
                        logger.info(f"Successfully deleted snapshot: {snapshot_identifier} in {DEFAULT_DR_REGION}")
                        total_deleted_count += 1
                    except Exception as delete_error:
                        logger.error(f"Error deleting snapshot {snapshot_identifier} in {DEFAULT_DR_REGION}: {str(delete_error)}")
                else:
                    logger.info(f"Snapshot {snapshot_identifier} in {DEFAULT_DR_REGION} is newer than {days_threshold} days, skipping...")
    
    except Exception as e:
        # Handle any errors during execution in DR region
        error_message = f"Error processing RDS snapshots in {DEFAULT_DR_REGION}: {str(e)}"
        logger.error(error_message)
        # You might want to return early if this error is critical
        # return { 'statusCode': 500, 'body': error_message }


    # Return success response
    logger.info(f"Cleanup completed in both regions. Total deleted {total_deleted_count} snapshots: {all_deleted_snapshots}")
    return {
        'statusCode': 200,
        'body': {
            'message': f'Successfully processed snapshots for database {db_instance_identifier} in {DEFAULT_PROD_REGION} and {DEFAULT_DR_REGION}',
            'deleted_snapshots': all_deleted_snapshots,
            'deleted_count': total_deleted_count
        }
    }


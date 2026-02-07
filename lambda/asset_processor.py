import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Processes S3 upload events and logs file information
    """
    try:
        for record in event['Records']:
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            
            logger.info(f"Image received: {key}")
            print(f"Image received: {key}")
            
        return {
            'statusCode': 200,
            'body': json.dumps('File processed successfully')
        }
        
    except Exception as e:
        logger.error(f"Error processing file: {str(e)}")
        raise
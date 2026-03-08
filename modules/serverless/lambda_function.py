import json
import boto3
import os
from datetime import datetime

def handler(event, context):
    """
    Lambda function to process events and trigger SNS, SQS, and CloudWatch
    """
    
    # Initialize AWS clients
    sns = boto3.client('sns')
    sqs = boto3.client('sqs')
    cloudwatch = boto3.client('cloudwatch')
    
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    sqs_queue_url = os.environ['SQS_QUEUE_URL']
    
    try:
        # Process the event
        message = {
            'timestamp': datetime.now().isoformat(),
            'event': event,
            'status': 'processed'
        }
        
        # Send message to SNS
        sns_response = sns.publish(
            TopicArn=sns_topic_arn,
            Message=json.dumps(message),
            Subject='TechHoDude Lambda Notification'
        )
        
        # Send message to SQS
        sqs_response = sqs.send_message(
            QueueUrl=sqs_queue_url,
            MessageBody=json.dumps(message)
        )
        
        # Send custom metrics to CloudWatch
        cloudwatch.put_metric_data(
            Namespace='TechHoDude/Lambda',
            MetricData=[
                {
                    'MetricName': 'ProcessedEvents',
                    'Value': 1.0,
                    'Unit': 'Count',
                    'Timestamp': datetime.now()
                }
            ]
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Event processed successfully',
                'sns_message_id': sns_response['MessageId'],
                'sqs_message_id': sqs_response['MessageId']
            })
        }
        
    except Exception as e:
        print(f"Error processing event: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }

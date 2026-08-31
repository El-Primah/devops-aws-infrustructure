import boto3
import os
import requests
import json
import urllib3


ec2 = boto3.client('ec2')

THRESHOLD_GB = 200
POWER_AUTOMATE_WEBHOOK_URL = os.environ.get('POWER_AUTOMATE_WEBHOOK_URL')

def create_adaptive_card(header_text, message_body):
    '''
    Create and return an adaptive card
    '''
    adaptive_card = {
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "type": "AdaptiveCard",
        "version": "1.2",
        "body": [
            {
                "type": "TextBlock",
                "text": header_text,
                "style": "heading",
                "size": "Large",
                "weight": "bolder",
                "wrap": True,
                "color": "bad"                
            },
           {
              "type": "TextBlock",
              "weight": "default",
              "wrap": True,
              "size": "default",
              "text": message_body
            },            
        ]
    }
    return adaptive_card

def send_adaptive_card_to_power_automate(webhook, adaptive_card):
    '''
    Send an adaptive card to Power Automate using a webhook
    '''
    http = urllib3.PoolManager()
    payload = json.dumps(
        {
            "type": "message",
            "attachments": [{"contentType": "application/vnd.microsoft.card.adaptive", "content": adaptive_card}]
        }
    )
    headers = {"Content-Type": "application/json"}
    response = http.request("POST", webhook, body=payload, headers=headers)
    print("response status:", response.status)
    if response.status >= 300:
        print(response)

def lambda_handler(event, context):
    try:
        volumes = ec2.describe_volumes(Filters=[{'Name': 'status', 'Values': ['available']}])
        
        alert_volumes = [vol for vol in volumes['Volumes'] if vol['Size'] > THRESHOLD_GB]
        
        if alert_volumes:
            print("Alert: Found available volumes exceeding 200GB.")
            
            header_text = "🚨 EBS Volume Alert!"
            message_body = "The following EBS volumes are available and exceed 200GB:\n"
            for vol in alert_volumes:
                message_body += f"Volume ID: {vol['VolumeId']}, Size: {vol['Size']}GB, AZ: {vol['AvailabilityZone']}\n"
            
            adaptive_card = create_adaptive_card(header_text, message_body)
            send_adaptive_card_to_power_automate(POWER_AUTOMATE_WEBHOOK_URL, adaptive_card)
        else:
            print("No volumes exceeding 200GB found.")
    
    except Exception as e:
        print(f"Error: {str(e)}")


import json
import boto3
import botocore

region = 'eu-north-1'
client = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    
    running_dev_clients = client.describe_instances(
    Filters=[{
        'Name': 'instance-state-name', 'Values': ['running']
        },           
        {
                'Name': 'tag:Name', 'Values': ['viktor-kysil-lambda']
        }
    ]
    )
    
    dev_ids = []
    for reservation in running_dev_clients['Reservations']:
        for instance in reservation['Instances']:
            dev_id = instance['InstanceId']
            dev_ids.append(dev_id)

    if len(dev_ids) != 0:
        try:
            print("Stopping running instances")
            for i_d in dev_ids:
                client.stop_instances(
                InstanceIds=[
                    i_d,
                ],
            )
        except botocore.exceptions.ClientError as error:
            print("There are currently no running instances with the tag: Name --> viktor-kysil-lambda" + error)

        response = "Successfully stopped running instances: " + str(i_d)
        print(response)
    
    return {
        'statusCode': 200
    }
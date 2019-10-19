import boto3
client = boto3.client('ec2', 'us-west-2')
print(client.describe_instances())
print(client.describe_key_pairs())

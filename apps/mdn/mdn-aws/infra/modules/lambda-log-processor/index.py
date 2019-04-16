# Lambda function to copy incoming cloudfront logs from s3 to a partitioned
# amazon athena format

import boto3
import os
import json
import urllib

s3 = boto3.client('s3')
dest_bucket = os.environ['DEST_BUCKET']
debug = os.environ['DEBUG']

def handler(event, context):

    if not dest_bucket:
        print("Unable to proceed, a destination bucket must be specified")
        os.exit(1)

    if debug == "True":
        print ("Received event: {}".format(json.dumps(event, indent=2)))

    # Iterate over all records in the list provided
    for record in event['Records']:

        bucket = str(record['s3']['bucket']['name'])
        key = str(urllib.parse.unquote(record['s3']['object']['key']))
        date = key.split('.')[1]

        # Split out date
        year, month, day, hour = date.split('-')

        # Create destination bucket format
        dest = 'year={}/month={}/day={}/{}'.format(
            year, month, day, key
        )

        try:
            resource = boto3.resource('s3')

            # Copy from source to destination
            copy_source = {
                'Bucket': bucket,
                'Key': key
            }

            bucket_obj = resource.Bucket(dest_bucket)
            bucket_obj.copy(copy_source, dest)

            if debug == "True":
                # Display source/destination in Lambda output log
                print ("- src: s3://{}/{}".format(bucket, key))
                print ("- dst: s3://{}/{}".format(dest_bucket, dest))

        except Exception as e:
            print("{}".format(e))
            raise(e)

        # Delete the source S3 object
        # Disable this line if a copy is sufficient
        #s3.delete_object(Bucket=bucket, Key=key)

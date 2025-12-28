import boto3
from dagster import asset


# Upload csv files to S3 bucket
@asset()
def upload_to_s3():
    s3 = boto3.client("s3")

    s3.upload_file(
        Filename="analytics/data/EEH_2025_s3_test.csv",
        Bucket="eeh-files",
        Key='eeh/EEH_2025_s3_test.csv'
    )
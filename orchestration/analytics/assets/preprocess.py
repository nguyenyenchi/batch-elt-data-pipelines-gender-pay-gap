import boto3

def upload_to_s3():
    s3 = boto3.client("s3")

    s3.upload_file(
        Filename="../data/S3/EEH_2025_s3_test.csv",
        Bucket="eeh-files",
        Key='eeh/EEH_2025_s3_test.csv'
    )
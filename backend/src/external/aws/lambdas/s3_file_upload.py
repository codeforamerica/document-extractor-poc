import json
import os

from src import context
from src.documents.upload_document import upload_file_data
from src.external.aws.s3 import S3
from src.storage import CloudStorage

appContext = context.ApplicationContext()
appContext.register(CloudStorage, S3())


def lambda_handler(event, context):
    try:
        if "body" not in event:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "No file provided"}),
            }

        body = json.loads(event["body"])
        try:
            bucket_name = os.environ.get("S3_BUCKET_NAME", "ocr-poc-flex")
            default_folder = "input/"
            document_id = upload_file_data(body["file_name"], body["file_content"], bucket_name, default_folder)
        except Exception as e:
            return {
                "statusCode": 500,
                "body": json.dumps({"error": str(e)}),
            }

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "File uploaded successfully.", "documentId": document_id}),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }

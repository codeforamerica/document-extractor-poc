#!/usr/bin/env python3

import boto3
import argparse
import json
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

def list_all_secrets(profile_name=None, region_name=None):
    """
    Lists all secrets in AWS Secrets Manager, including those pending deletion.

    Args:
        profile_name (str, optional): The AWS CLI profile to use.
        region_name (str, optional): The AWS region to use.
    """
    try:
        session_args = {}
        if profile_name:
            session_args['profile_name'] = profile_name
        if region_name:
            session_args['region_name'] = region_name

        session = boto3.Session(**session_args)
        client = session.client('secretsmanager')

        print(f"Fetching secrets... (Profile: {profile_name or 'default'}, Region: {client.meta.region_name or 'default'})")

        paginator = client.get_paginator('list_secrets')
        all_secrets = []

        for page in paginator.paginate(IncludePlannedDeletion=True):
            all_secrets.extend(page.get('SecretList', []))

        if not all_secrets:
            print("No secrets found.")
            return

        print(f"\nFound {len(all_secrets)} secret(s):\n")
        print(f"{'Name':<50} {'ARN':<100} {'Status':<15} {'Deletion Date'}")
        print("-" * 180)

        for secret in all_secrets:
            name = secret.get('Name', 'N/A')
            arn = secret.get('ARN', 'N/A')
            deleted_date = secret.get('DeletedDate')

            status = "Pending Deletion" if deleted_date else "Active"
            deletion_date_str = deleted_date.strftime('%Y-%m-%d %H:%M:%S %Z') if deleted_date else "N/A"

            print(f"{name:<50} {arn:<100} {status:<15} {deletion_date_str}")

        print("\nDetailed JSON output of all secrets:")
        print(json.dumps(all_secrets, default=str, indent=2))


    except (NoCredentialsError, PartialCredentialsError):
        print("Error: AWS credentials not found. Configure your credentials (e.g., via AWS CLI 'aws configure').")
        if profile_name:
            print(f"Ensure the profile '{profile_name}' is correctly configured.")
    except ClientError as e:
        if e.response['Error']['Code'] == 'AccessDeniedException':
            print(f"Error: Access Denied. The configured AWS credentials do not have permission to list secrets.")
            print(f"Required IAM permission: 'secretsmanager:ListSecrets'")
        else:
            print(f"An AWS ClientError occurred: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="List AWS Secrets Manager secrets, including those pending deletion.")
    parser.add_argument(
        "--profile",
        help="AWS CLI profile to use. If not provided, uses the default profile."
    )
    parser.add_argument(
        "--region",
        help="AWS region to use. If not provided, uses the default region from the profile or environment variables."
    )
    args = parser.parse_args()

    list_all_secrets(profile_name=args.profile, region_name=args.region)

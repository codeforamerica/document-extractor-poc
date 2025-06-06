#!/usr/bin/env python3
"""
Get S3 bucket location information.

This script retrieves the AWS region where an S3 bucket is located.
Useful for verifying bucket locations before configuring Terraform backends.
"""

import argparse
import boto3
import json
import sys
from botocore.exceptions import ClientError, NoCredentialsError


def get_bucket_location(bucket_name, profile_name=None, output_format='json'):
    """
    Get the location (region) of an S3 bucket.

    Args:
        bucket_name (str): Name of the S3 bucket
        profile_name (str, optional): AWS profile to use
        output_format (str): Output format ('json', 'text', 'region-only')

    Returns:
        dict: Bucket location information
    """
    try:
        # Create session with profile if specified
        if profile_name:
            session = boto3.Session(profile_name=profile_name)
            s3_client = session.client('s3')
        else:
            s3_client = boto3.client('s3')

        # Get bucket location
        response = s3_client.get_bucket_location(Bucket=bucket_name)

        # AWS returns None for us-east-1, so we need to handle that
        location = response.get('LocationConstraint')
        if location is None:
            location = 'us-east-1'

        result = {
            'bucket_name': bucket_name,
            'region': location,
            'location_constraint': response.get('LocationConstraint')
        }

        return result

    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'NoSuchBucket':
            print(f"Error: Bucket '{bucket_name}' does not exist.", file=sys.stderr)
        elif error_code == 'AccessDenied':
            print(f"Error: Access denied to bucket '{bucket_name}'. Check your permissions.", file=sys.stderr)
        else:
            print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except NoCredentialsError:
        print("Error: AWS credentials not found. Please configure your credentials.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Get S3 bucket location information",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python get_s3_bucket_location.py my-bucket
  python get_s3_bucket_location.py my-bucket --profile my-profile
  python get_s3_bucket_location.py my-bucket --output region-only
  python get_s3_bucket_location.py my-bucket --profile AWSAdministratorAccess-328307993388 --output text
        """
    )

    parser.add_argument(
        'bucket_name',
        help='Name of the S3 bucket to check'
    )

    parser.add_argument(
        '--profile',
        help='AWS profile to use (optional)'
    )

    parser.add_argument(
        '--output',
        choices=['json', 'text', 'region-only'],
        default='json',
        help='Output format (default: json)'
    )

    args = parser.parse_args()

    # Get bucket location
    result = get_bucket_location(args.bucket_name, args.profile, args.output)

    # Output results based on format
    if args.output == 'json':
        print(json.dumps(result, indent=2))
    elif args.output == 'text':
        print(f"Bucket: {result['bucket_name']}")
        print(f"Region: {result['region']}")
        print(f"Location Constraint: {result['location_constraint']}")
    elif args.output == 'region-only':
        print(result['region'])


if __name__ == '__main__':
    main()

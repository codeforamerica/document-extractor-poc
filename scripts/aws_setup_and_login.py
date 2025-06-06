#!/usr/bin/env python3
"""
AWS Setup and Login Script for Document Extractor Project

This script handles:
1. AWS SSO login process
2. Profile validation
3. S3 bucket creation for Terraform state
4. DynamoDB table creation for state locking
5. Pre-flight checks before OpenTofu/Terraform operations

Usage:
    python aws_setup_and_login.py --profile AWSAdministratorAccess-328307993388
    python aws_setup_and_login.py --profile AWSAdministratorAccess-328307993388 --region us-east-1
    python aws_setup_and_login.py --create-backend-resources
"""

import argparse
import boto3
import json
import subprocess
import sys
import time
from botocore.exceptions import ClientError, NoCredentialsError


class AWSSetupManager:
    def __init__(self, profile_name=None, region='us-east-1'):
        self.profile_name = profile_name
        self.region = region
        self.sso_start_url = "https://codeforamerica.awsapps.com/start/#"

        # Backend configuration
        self.backend_config = {
            'bucket_name': f'document-extractor-dev-opentofu-state',
            'dynamodb_table': 'terraform-locks-dev',
            'region': region
        }

    def check_sso_login_status(self):
        """Check if AWS SSO login is active"""
        try:
            if self.profile_name:
                session = boto3.Session(profile_name=self.profile_name)
            else:
                session = boto3.Session()

            sts_client = session.client('sts', region_name=self.region)
            identity = sts_client.get_caller_identity()

            print(f"✅ AWS credentials are valid")
            print(f"   Account ID: {identity['Account']}")
            print(f"   User ARN: {identity['Arn']}")
            return True

        except Exception as e:
            print(f"❌ AWS credentials not valid: {e}")
            return False

    def perform_sso_login(self):
        """Perform AWS SSO login"""
        print(f"🔐 Initiating AWS SSO login...")
        print(f"   SSO Start URL: {self.sso_start_url}")

        try:
            if self.profile_name:
                cmd = ['aws', 'sso', 'login', '--profile', self.profile_name]
            else:
                cmd = ['aws', 'sso', 'login']

            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode == 0:
                print("✅ AWS SSO login successful")
                return True
            else:
                print(f"❌ AWS SSO login failed: {result.stderr}")
                return False

        except Exception as e:
            print(f"❌ Error during SSO login: {e}")
            return False

    def get_s3_client(self):
        """Get S3 client with proper session"""
        if self.profile_name:
            session = boto3.Session(profile_name=self.profile_name)
            return session.client('s3', region_name=self.region)
        else:
            return boto3.client('s3', region_name=self.region)

    def get_dynamodb_client(self):
        """Get DynamoDB client with proper session"""
        if self.profile_name:
            session = boto3.Session(profile_name=self.profile_name)
            return session.client('dynamodb', region_name=self.region)
        else:
            return boto3.client('dynamodb', region_name=self.region)

    def check_s3_bucket_exists(self, bucket_name=None):
        """Check if S3 bucket exists and get its region"""
        if bucket_name is None:
            bucket_name = self.backend_config['bucket_name']

        try:
            s3_client = self.get_s3_client()

            # Check if bucket exists
            s3_client.head_bucket(Bucket=bucket_name)

            # Get bucket location
            location_response = s3_client.get_bucket_location(Bucket=bucket_name)
            bucket_region = location_response.get('LocationConstraint')
            if bucket_region is None:
                bucket_region = 'us-east-1'

            print(f"✅ S3 bucket '{bucket_name}' exists in region '{bucket_region}'")
            return True, bucket_region

        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == '404':
                print(f"❌ S3 bucket '{bucket_name}' does not exist")
                return False, None
            else:
                print(f"❌ Error checking bucket: {e}")
                return False, None

    def create_s3_bucket(self, bucket_name=None):
        """Create S3 bucket for Terraform state"""
        if bucket_name is None:
            bucket_name = self.backend_config['bucket_name']

        try:
            s3_client = self.get_s3_client()

            print(f"🪣 Creating S3 bucket '{bucket_name}' in region '{self.region}'...")

            if self.region == 'us-east-1':
                # us-east-1 doesn't need LocationConstraint
                s3_client.create_bucket(Bucket=bucket_name)
            else:
                s3_client.create_bucket(
                    Bucket=bucket_name,
                    CreateBucketConfiguration={'LocationConstraint': self.region}
                )

            # Enable versioning
            s3_client.put_bucket_versioning(
                Bucket=bucket_name,
                VersioningConfiguration={'Status': 'Enabled'}
            )

            # Enable encryption
            s3_client.put_bucket_encryption(
                Bucket=bucket_name,
                ServerSideEncryptionConfiguration={
                    'Rules': [
                        {
                            'ApplyServerSideEncryptionByDefault': {
                                'SSEAlgorithm': 'AES256'
                            }
                        }
                    ]
                }
            )

            print(f"✅ S3 bucket '{bucket_name}' created successfully")
            return True

        except ClientError as e:
            print(f"❌ Error creating S3 bucket: {e}")
            return False

    def check_dynamodb_table_exists(self, table_name=None):
        """Check if DynamoDB table exists"""
        if table_name is None:
            table_name = self.backend_config['dynamodb_table']

        try:
            dynamodb_client = self.get_dynamodb_client()

            response = dynamodb_client.describe_table(TableName=table_name)
            status = response['Table']['TableStatus']

            print(f"✅ DynamoDB table '{table_name}' exists with status '{status}'")
            return True, status

        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'ResourceNotFoundException':
                print(f"❌ DynamoDB table '{table_name}' does not exist")
                return False, None
            else:
                print(f"❌ Error checking DynamoDB table: {e}")
                return False, None

    def create_dynamodb_table(self, table_name=None):
        """Create DynamoDB table for Terraform state locking"""
        if table_name is None:
            table_name = self.backend_config['dynamodb_table']

        try:
            dynamodb_client = self.get_dynamodb_client()

            print(f"🗃️ Creating DynamoDB table '{table_name}' in region '{self.region}'...")

            dynamodb_client.create_table(
                TableName=table_name,
                KeySchema=[
                    {
                        'AttributeName': 'LockID',
                        'KeyType': 'HASH'
                    }
                ],
                AttributeDefinitions=[
                    {
                        'AttributeName': 'LockID',
                        'AttributeType': 'S'
                    }
                ],
                BillingMode='PAY_PER_REQUEST',
                Tags=[
                    {
                        'Key': 'Purpose',
                        'Value': 'TerraformStateLocking'
                    },
                    {
                        'Key': 'Project',
                        'Value': 'DocumentExtractor'
                    }
                ]
            )

            print(f"⏳ Waiting for DynamoDB table to become active...")
            waiter = dynamodb_client.get_waiter('table_exists')
            waiter.wait(TableName=table_name, WaiterConfig={'Delay': 2, 'MaxAttempts': 30})

            print(f"✅ DynamoDB table '{table_name}' created successfully")
            return True

        except ClientError as e:
            print(f"❌ Error creating DynamoDB table: {e}")
            return False

    def setup_backend_resources(self):
        """Create all required backend resources"""
        print(f"\n🏗️ Setting up backend resources for region '{self.region}'...")

        # Check and create S3 bucket
        bucket_exists, bucket_region = self.check_s3_bucket_exists()
        if not bucket_exists:
            if not self.create_s3_bucket():
                return False
        elif bucket_region != self.region:
            print(f"⚠️ Warning: Bucket exists in '{bucket_region}' but you're targeting '{self.region}'")

        # Check and create DynamoDB table
        table_exists, table_status = self.check_dynamodb_table_exists()
        if not table_exists:
            if not self.create_dynamodb_table():
                return False

        return True

    def print_setup_summary(self):
        """Print setup summary and next steps"""
        print(f"\n📋 Setup Summary:")
        print(f"   Profile: {self.profile_name or 'default'}")
        print(f"   Region: {self.region}")
        print(f"   S3 Bucket: {self.backend_config['bucket_name']}")
        print(f"   DynamoDB Table: {self.backend_config['dynamodb_table']}")

        print(f"\n🚀 Ready for OpenTofu operations!")
        print(f"   You can now run: tofu init -reconfigure")

        # Print environment setup commands
        if self.profile_name:
            print(f"\n💡 Environment setup commands:")
            print(f"   export AWS_PROFILE={self.profile_name}")
            print(f"   export AWS_REGION={self.region}")


def main():
    parser = argparse.ArgumentParser(
        description="AWS Setup and Login for Document Extractor Project",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        '--profile',
        default='AWSAdministratorAccess-328307993388',
        help='AWS profile to use'
    )

    parser.add_argument(
        '--region',
        default='us-east-1',
        help='AWS region to use'
    )

    parser.add_argument(
        '--create-backend-resources',
        action='store_true',
        help='Create S3 bucket and DynamoDB table for Terraform backend'
    )

    parser.add_argument(
        '--force-login',
        action='store_true',
        help='Force AWS SSO login even if credentials seem valid'
    )

    args = parser.parse_args()

    # Initialize setup manager
    setup_manager = AWSSetupManager(profile_name=args.profile, region=args.region)

    print(f"🚀 AWS Setup for Document Extractor Project")
    print(f"   Profile: {args.profile}")
    print(f"   Region: {args.region}")

    # Check current login status
    if not args.force_login and setup_manager.check_sso_login_status():
        print("✅ Already logged in to AWS SSO")
    else:
        # Perform SSO login
        if not setup_manager.perform_sso_login():
            print("❌ Login failed. Exiting.")
            sys.exit(1)

        # Verify login worked
        if not setup_manager.check_sso_login_status():
            print("❌ Login verification failed. Exiting.")
            sys.exit(1)

    # Set up backend resources if requested
    if args.create_backend_resources:
        if not setup_manager.setup_backend_resources():
            print("❌ Failed to setup backend resources. Exiting.")
            sys.exit(1)
    else:
        # Just check if resources exist
        print(f"\n🔍 Checking backend resources...")
        setup_manager.check_s3_bucket_exists()
        setup_manager.check_dynamodb_table_exists()

    # Print summary
    setup_manager.print_setup_summary()


if __name__ == '__main__':
    main()

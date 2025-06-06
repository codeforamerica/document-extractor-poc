#!/usr/bin/env python3

import boto3
import argparse
import sys
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

# Hardcoded list of allowed secret names to delete (for safety)
ALLOWED_SECRETS = ["private-key", "public-key", "username", "password"]

def find_secrets_by_name(client, secret_name):
    """
    Find all secrets that contain the given name.

    Args:
        client: boto3 secretsmanager client
        secret_name (str): The name to search for in secret names

    Returns:
        list: List of matching secret names
    """
    try:
        paginator = client.get_paginator('list_secrets')
        matching_secrets = []

        for page in paginator.paginate():
            for secret in page.get('SecretList', []):
                if secret_name in secret.get('Name', ''):
                    matching_secrets.append(secret.get('Name'))

        return matching_secrets
    except Exception as e:
        print(f"Error searching for secrets: {e}")
        return []

def delete_secret(client, secret_name, force=True):
    """
    Delete a secret from AWS Secrets Manager.

    Args:
        client: boto3 secretsmanager client
        secret_name (str): The exact name of the secret to delete
        force (bool): Whether to force deletion without recovery period

    Returns:
        bool: True if successful, False otherwise
    """
    try:
        response = client.delete_secret(
            SecretId=secret_name,
            ForceDeleteWithoutRecovery=force
        )

        print(f"✅ Successfully deleted secret: {secret_name}")
        if force:
            print(f"   Secret was permanently deleted (no recovery possible)")
        else:
            deletion_date = response.get('DeletionDate')
            print(f"   Secret scheduled for deletion on: {deletion_date}")

        return True

    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'ResourceNotFoundException':
            print(f"❌ Secret not found: {secret_name}")
        elif error_code == 'InvalidRequestException':
            print(f"❌ Invalid request for secret: {secret_name} - {e.response['Error']['Message']}")
        elif error_code == 'AccessDeniedException':
            print(f"❌ Access denied for secret: {secret_name}")
        else:
            print(f"❌ Error deleting secret {secret_name}: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error deleting secret {secret_name}: {e}")
        return False

def confirm_deletion(secret_names):
    """
    Ask user to confirm deletion of secrets.

    Args:
        secret_names (list): List of secret names to delete

    Returns:
        bool: True if user confirms, False otherwise
    """
    print("\n" + "="*60)
    print("⚠️  WARNING: You are about to PERMANENTLY DELETE the following secrets:")
    print("="*60)

    for name in secret_names:
        print(f"  • {name}")

    print("\n🔥 This action CANNOT be undone!")
    print("🔥 Secrets will be PERMANENTLY DELETED with no recovery period!")
    print("="*60)

    while True:
        confirm = input("\nType 'DELETE' (all caps) to confirm deletion, or 'cancel' to abort: ").strip()

        if confirm == "DELETE":
            return True
        elif confirm.lower() == "cancel":
            print("❌ Deletion cancelled.")
            return False
        else:
            print("❌ Invalid input. Please type 'DELETE' to confirm or 'cancel' to abort.")

def main():
    parser = argparse.ArgumentParser(
        description="Delete specific AWS Secrets Manager secrets with force deletion. "
                   f"Only allows deletion of: {', '.join(ALLOWED_SECRETS)}"
    )
    parser.add_argument(
        "secret_name",
        choices=ALLOWED_SECRETS,
        help=f"Name of the secret to delete. Must be one of: {', '.join(ALLOWED_SECRETS)}"
    )
    parser.add_argument(
        "--profile",
        help="AWS CLI profile to use. If not provided, uses the default profile."
    )
    parser.add_argument(
        "--region",
        help="AWS region to use. If not provided, uses the default region from the profile."
    )
    parser.add_argument(
        "--no-force",
        action="store_true",
        help="Don't force deletion (use standard 30-day recovery period instead)"
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip confirmation prompt (dangerous!)"
    )

    args = parser.parse_args()

    try:
        session_args = {}
        if args.profile:
            session_args['profile_name'] = args.profile
        if args.region:
            session_args['region_name'] = args.region

        session = boto3.Session(**session_args)
        client = session.client('secretsmanager')

        print(f"Searching for secrets containing '{args.secret_name}'...")
        print(f"Profile: {args.profile or 'default'}, Region: {client.meta.region_name or 'default'}")

        # Find all secrets that contain the specified name
        matching_secrets = find_secrets_by_name(client, args.secret_name)

        if not matching_secrets:
            print(f"❌ No secrets found containing '{args.secret_name}'")
            return

        print(f"\nFound {len(matching_secrets)} secret(s) containing '{args.secret_name}':")
        for secret in matching_secrets:
            print(f"  • {secret}")

        # Confirm deletion unless --yes flag is used
        if not args.yes:
            if not confirm_deletion(matching_secrets):
                return

        # Delete each matching secret
        print(f"\nDeleting secrets...")
        success_count = 0
        force_delete = not args.no_force

        for secret_name in matching_secrets:
            if delete_secret(client, secret_name, force=force_delete):
                success_count += 1

        print(f"\n📊 Summary: {success_count}/{len(matching_secrets)} secrets deleted successfully.")

        if success_count == len(matching_secrets):
            print("🎉 All secrets deleted successfully!")
        elif success_count > 0:
            print("⚠️  Some secrets were deleted, but errors occurred with others.")
        else:
            print("❌ No secrets were deleted due to errors.")

    except (NoCredentialsError, PartialCredentialsError):
        print("❌ Error: AWS credentials not found. Configure your credentials (e.g., via AWS CLI 'aws configure').")
        if args.profile:
            print(f"Ensure the profile '{args.profile}' is correctly configured.")
        sys.exit(1)
    except Exception as e:
        print(f"❌ An unexpected error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

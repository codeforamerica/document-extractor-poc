# Deploying Infrastructure with OpenTofu

This guide outlines the steps to deploy the infrastructure defined in the `iac` directory using OpenTofu, an open-source alternative to Terraform.

## Introduction

OpenTofu is a fork of Terraform v1.5.x, initiated due to Terraform's license change. It aims to be a drop-in replacement for Terraform, meaning your existing Terraform configuration files (`.tf`) can typically be used with OpenTofu without modification.

We will use the existing S3 backend configuration to store the OpenTofu state.

## Prerequisites

1.  **Install OpenTofu**:
    *   Follow the official OpenTofu installation guide for your operating system: [https://opentofu.org/docs/intro/install/](https://opentofu.org/docs/intro/install/)

2.  **AWS CLI Configured**:
    *   Ensure the AWS CLI is installed and configured.
    *   The backend configuration in `iac/main.tf` specifies `profile = "AWSAdministratorAccess-328307993388"`. Make sure this AWS profile is configured in your `~/.aws/credentials` and `~/.aws/config` files.

3.  **S3 Bucket for State**:
    *   You mentioned an existing S3 bucket: `document-extractor-dev-opentofu-state`. OpenTofu will use this bucket to store its state file.

4.  **DynamoDB Table for Locks**:
    *   The backend configuration specifies `dynamodb_table = "terraform-locks-dev"`.
    *   If this table does not exist in the `us-west-1` region, OpenTofu will attempt to create it during the `init` step, provided your AWS user/role has the necessary DynamoDB permissions (`dynamodb:CreateTable`, `dynamodb:DescribeTable`, etc.).

## Deployment Steps

1.  **Navigate to the IAC Directory**:
    ```bash
    cd iac
    ```

2.  **Initialize OpenTofu**:
    This command initializes the working directory, downloads necessary provider plugins, and configures the backend. OpenTofu will automatically detect and use the backend configuration defined in `main.tf`.
    ```bash
    tofu init
    ```
    You should see output indicating successful initialization and backend setup using S3.

    If `tofu init` has trouble finding or configuring the backend, you can explicitly provide the backend configuration (though it should not be necessary if `main.tf` is correctly configured):
    ```bash
    tofu init \
        -backend-config="bucket=document-extractor-dev-opentofu-state" \
        -backend-config="key=document-extractor/terraform.tfstate" \
        -backend-config="region=us-west-1" \
        -backend-config="dynamodb_table=terraform-locks-dev" \
        -backend-config="encrypt=true" \
        -backend-config="profile=AWSAdministratorAccess-328307993388"
    ```

3.  **Validate Configuration (Optional but Recommended)**:
    Check if the configuration is syntactically valid and internally consistent.
    ```bash
    tofu validate
    ```

4.  **Create an Execution Plan**:
    This command creates an execution plan, showing you what actions OpenTofu will take to achieve the desired state defined in your configuration files.
    ```bash
    tofu plan -out=tfplan
    ```
    Review the plan carefully to ensure it matches your expectations.

5.  **Apply the Configuration**:
    Apply the changes required to reach the desired state of the configuration.
    ```bash
    tofu apply tfplan \
        -backend-config="bucket=document-extractor-dev-opentofu-state" \
        -backend-config="key=document-extractor/terraform.tfstate" \
        -backend-config="region=us-west-1" \
        -backend-config="dynamodb_table=terraform-locks-dev" \
        -backend-config="encrypt=true" \
        -backend-config="profile=AWSAdministratorAccess-328307993388"
    ```
    OpenTofu will prompt for confirmation before proceeding. Type `yes` to approve.

Once the apply command completes, your infrastructure will be deployed.

## Backend Configuration

Your `iac/main.tf` file already contains the S3 backend configuration that OpenTofu will use:

```terraform
terraform {
  backend "s3" {
    bucket         = "document-extractor-dev-opentofu-state"
    key            = "document-extractor/terraform.tfstate" # This will be the path to the state file within the bucket
    region         = "us-west-1"
    dynamodb_table = "terraform-locks-dev"
    encrypt        = true
    profile        = "AWSAdministratorAccess-328307993388"
  }
}
```
OpenTofu is designed to be compatible with Terraform state files. Since you've already torn down the infrastructure with Terraform, OpenTofu will create a new state file in the specified S3 bucket and key if one doesn't exist, or use an existing one if present (though it should be empty or reflect a destroyed state).

## Destroying Infrastructure

If you need to tear down the infrastructure deployed by OpenTofu:

1.  **Create a Destroy Plan**:
    ```bash
    tofu plan -destroy -out=tfdestroyplan
    ```
    Review the plan to see what resources will be destroyed.

2.  **Destroy the Infrastructure**:
    ```bash
    tofu apply tfdestroyplan
    ```
    Alternatively, you can run `tofu destroy` and OpenTofu will generate a plan and ask for confirmation.

    OpenTofu will prompt for confirmation before proceeding. Type `yes` to approve.

This should guide you through deploying and managing your infrastructure with OpenTofu!

## Troubleshooting

### Secrets Manager: "secret with this name is already scheduled for deletion"

If your `tofu apply` command fails with an error similar to:

```
Error: creating Secrets Manager Secret (example-secret-name): ... InvalidRequestException: You can't create this secret because a secret with this name is already scheduled for deletion.
```

This means that secrets with the same names as those defined in your `secrets.tf` (e.g., `document-extractor-dev-private-key`, `document-extractor-dev-public-key`, etc.) were recently deleted and are currently in a recovery window (typically 7-30 days). AWS Secrets Manager prevents the creation of a new secret with the same name during this period.

You have a few options to resolve this:

**Option 1: Wait for the Recovery Window to Expire**

*   The simplest option is to wait until the recovery window for the deleted secrets has passed. After this period, the secret names will become available again, and `tofu apply` should succeed.

**Option 2: Force Delete the Secrets (Use with Caution)**

*   If you are certain you do not need to recover the old secret values, you can force delete them from AWS Secrets Manager. This will make the names available immediately.
    *   **Using AWS Management Console**:
        1.  Navigate to AWS Secrets Manager in the AWS console.
        2.  Find the secrets that are scheduled for deletion (they might have a status indicating this).
        3.  Select the secret and look for an option to permanently delete it or modify the deletion schedule to delete it immediately. The exact steps might vary slightly depending on the console interface.
    *   **Using AWS CLI**:
        You can use the `aws secretsmanager delete-secret` command with the `--force-delete-without-recovery` flag. You'll first need to find the Secret ARN or name.

        *   **To list all secrets, including those pending deletion, to find the correct name or ARN:**
            ```bash
            aws secretsmanager list-secrets --include-pending-deletion --region us-west-1 --profile AWSAdministratorAccess-328307993388 --output json
            ```
            Review the output. Look for secrets with a `DeletionDate` field; these are the ones scheduled for deletion. Note the `Name` or `ARN` of the secrets you intend to manage.

        *   **To force delete a secret:**
            ```bash
            # Example for one secret (repeat for all problematic secrets):
            aws secretsmanager delete-secret --secret-id arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-private-key-XXXXXX --force-delete-without-recovery --region us-west-1 --profile AWSAdministratorAccess-328307993388
            # Or by name (if it's unique and you're sure it's the correct one scheduled for deletion)
            # aws secretsmanager delete-secret --secret-id document-extractor-dev-private-key --force-delete-without-recovery --region us-west-1 --profile AWSAdministratorAccess-328307993388
            ```
        **Important**: Replace `us-west-1` with your actual region if different, and `AWSAdministratorAccess-328307993388` with your AWS CLI profile. The `-XXXXXX` part of the ARN is a placeholder for the unique suffix AWS adds to secret ARNs; you'd typically use the full name if it's in a scheduled deletion state without the suffix, or find the exact ARN.

**Option 3: Change Secret Names in Configuration**

*   If you want to proceed immediately without waiting or force-deleting, you can modify your `iac/secrets.tf` file to use different names for the secrets. For example, append a suffix:
    ```terraform
    resource "aws_secretsmanager_secret" "private_key" {
      name = "document-extractor-dev-private-key-v2"
      # ... other attributes
    }
    // Repeat for other secrets
    ```
    After changing the names, run `tofu plan -out=tfplan` and `tofu apply tfplan` again.

Choose the option that best suits your needs. After resolving the secret name conflict, you should be able to successfully apply your OpenTofu configuration.

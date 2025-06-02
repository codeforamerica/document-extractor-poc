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
    *   You mentioned an existing S3 bucket: `document-extractor-dev-terraform-state`. OpenTofu will use this bucket to store its state file.

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
        -backend-config="bucket=document-extractor-dev-terraform-state" \
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
    tofu apply tfplan
    ```
    OpenTofu will prompt for confirmation before proceeding. Type `yes` to approve.

Once the apply command completes, your infrastructure will be deployed.

## Backend Configuration

Your `iac/main.tf` file already contains the S3 backend configuration that OpenTofu will use:

```terraform
terraform {
  backend "s3" {
    bucket         = "document-extractor-dev-terraform-state"
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

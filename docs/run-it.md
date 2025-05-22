# Deployment Guide

This guide will help you deploy the Document Extractor POC to a fresh AWS account.

## Prerequisites

- AWS account with admin access
- AWS CLI installed and configured with admin credentials
- Terraform (v1.0.0 or later)
- Python 3.13 or later
- [uv](https://docs.astral.sh/uv/) Python package manager
   - Node.js and npm (for frontend deployment)
- Git (for cloning the repository)

## 1. Repository Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd document-extractor-poc
   ```

2. Navigate to the infrastructure directory:
   ```bash
   cd iac
   ```

## 2. Understanding Terraform State Management (For Beginners)

### What is Terraform State?
Terraform uses a state file (`.tfstate`) to track what resources it has created in your AWS account. This file is crucial - it's how Terraform knows what it's managing.

### Where to Store the State File
For a fresh deployment, you need to create an S3 bucket to store this state file:

1. **Create a state bucket** in your AWS account:
   - Go to the AWS console → S3 → Create bucket
   - Name it something like `document-extractor-dev-terraform-state`
   - Keep default settings and create the bucket

2. **Create a DynamoDB table** for state locking:
   - Go to AWS console → DynamoDB → Create table
   - Name it something like `terraform-locks-dev`
   - Primary key: `LockID` (type String)
   - Use default settings and create table

3. **Update your backend configuration** in `iac/main.tf`:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "document-extractor-dev-terraform-state"  # Replace with your bucket name
       key            = "document-extractor/terraform.tfstate"
       region         = "us-east-1"
       dynamodb_table = "terraform-locks-dev"  # The DynamoDB table you created
       encrypt        = true
     }
   }
   ```

> **Note**: You only need to set this up once. Terraform will create and manage the state file for you after this.

## 3. Setting Up Your Variables

Terraform needs some information from you to deploy properly. Create a file named `terraform.tfvars` in the `iac` directory:

```hcl
# Required: Choose a deployment environment name
environment = "dev"  # Use a simple name like "dev", "test", or "prod"

# Optional: Change AWS region if needed (defaults to "us-east-1" if not specified)
region = "us-east-1"

# Advanced: Required, but can be empty if not using custom form adapters
textract_form_adapters_env_var_mapping = {}
```

> **What these variables do**:
> - `environment`: Adds a suffix to resource names to separate different deployments (e.g., dev vs. prod)
> - `region`: Which AWS region to deploy to (us-east-1 is AWS's N. Virginia region)
> - `textract_form_adapters_env_var_mapping`: Required variable for form adapter configurations. Can be set to an empty map (`{}`) if you're not using custom form adapters.

## 4. Build the Backend

1. Navigate to the backend directory:
   ```bash
   cd ../backend
   ```

2. Set up the Python environment:
   ```bash
   uv sync
   ```

3. Build the Lambda deployment package:
   ```bash
   uv run build.py
   ```

   This will create the artifact at `backend/dist/lambda.zip`.

## 5. Build the Frontend

1. Navigate to the frontend directory:
   ```bash
   cd ../ui
   ```

2. Install dependencies:
   ```bash
   npm ci
   ```

3. Build the frontend:
   ```bash
   npm run build
   ```

   This will create the build artifacts in the `ui/dist/` directory.

## 6. Deploy Infrastructure with Terraform

1. Navigate back to the infrastructure directory:
   ```bash
   cd ../iac
   ```

2. Initialize Terraform (downloads required providers and sets up your backend):
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 terraform init
   ```
   > If you get an error about the backend configuration, double-check that you've created the S3 bucket and DynamoDB table, and that your AWS credentials have permission to access them.

3. See what Terraform will create (this doesn't make any changes yet):
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 terraform  plan -out=tfplan
   ```
   > This step will show you all the AWS resources that will be created. It might look overwhelming, but you don't need to understand every detail.

4. Create the actual resources in AWS:
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 terraform apply "tfplan"
   ```
   > This step will take 5-10 minutes to complete. When finished, it will output important information like the CloudFront URL that you'll use to access your application.

5. Save the outputs somewhere safe - you'll need them later!

   > **Important**: These resources will cost money in your AWS account as long as they exist. See the Cleanup section for how to remove them when you're done.

## 7. Post-Deployment Steps

### Authentication Setup (Required)

1. Generate an RSA private key in PEM format:
   ```bash
   openssl genrsa -out private-key.pem 2048
   ```

2. Upload it to AWS Secrets Manager with `private-key` in the name:
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name private-key --secret-string file://private-key.pem
   ```

3. Generate a public key from the private key:
   ```bash
   openssl rsa -in private-key.pem -pubout -out public-key.pem
   ```

4. Upload the public key to AWS Secrets Manager:
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name public-key --secret-string file://public-key.pem
   ```

5. Choose a username and upload it to Secrets Manager:
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name username --secret-string "hugo-testing-testing"
   ```

6. Generate a hashed password:
   ```bash
   cd ./backend/
   echo 'import bcrypt;print(bcrypt.hashpw(b"your_strong_password", bcrypt.gensalt()).decode())' | uv run -
   ```

7. Upload the hashed password to Secrets Manager:
   ```bash
   AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name password --secret-string "$2b$12$rumyUnUwF9NvnWaCkHRDYOeQCyn22QP6LgbR4GEEGkHsr3urD9Bau"
   ```

# correct commands code expects:
AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name document-extractor-dev-username --secret-string "hugo-testing-testing"

AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name document-extractor-dev-password --secret-string "$2b$12$rumyUnUwF9NvnWaCkHRDYOeQCyn22QP6LgbR4GEEGkHsr3urD9Bau"

AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name document-extractor-dev-private-key --secret-string file://private-key.pem

AWS_PROFILE=AWSAdministratorAccess-328307993388 aws secretsmanager create-secret --name document-extractor-dev-public-key --secret-string file://public-key.pem

## 8. Additional Post-Deployment Steps

1. **Set up DNS**:
   - Create a Route 53 hosted zone for your domain
   - Add an A record pointing to the CloudFront distribution
   - Update the CloudFront distribution with your custom domain and SSL certificate

2. **Configure Environment Variables**:
   - Set any necessary environment variables in AWS Lambda and other services
   - Verify all secrets in AWS Secrets Manager

3. **Monitoring and Logging**:
   - Set up CloudWatch Alarms for critical metrics
   - Configure log retention policies

## 9. Accessing the Application

After deployment, you can access the application via:
- The CloudFront distribution URL (found in AWS Console or Terraform outputs)
- Your custom domain (if configured)

You will need to use the username and password you configured in the authentication setup.

## 10. Cleanup (When Needed)

To remove all deployed resources:

```bash
cd iac
terraform destroy
```

## Troubleshooting

- **Terraform State Locking Issues**:
  - If you encounter state locking issues, you may need to manually remove the lock from the DynamoDB table

- **Permission Issues**:
  - Ensure your AWS credentials have sufficient permissions
  - Check CloudTrail for any denied API calls

- **Frontend Not Updating**:
  - Clear CloudFront cache
  - Verify S3 bucket policies and CloudFront origin settings

## Support

For additional help, please refer to the project documentation or open an issue in the repository.




==== notes on public private cloudfront
Added secure private access:

cloudfront.tf • Introduced aws_cloudfront_origin_access_control (SigV4).
• S3 origin now references bucket_regional_domain_name, attaches the new OAC via origin_access_control_id, and uses s3_origin_config.
• Added default_root_object = "index.html".
s3.tf • Replaced permissive resources with private ones:
– New aws_s3_bucket_public_access_block.private_website keeps public blocked while allowing CloudFront.
– New bucket-policy (website_read) built from data.aws_iam_policy_document.cf_read, which permits s3:GetObject only when the caller is CloudFront and the request’s SourceArn equals the distribution ARN.
• Old public-allowing block/policy resources are commented for removal.
Now only CloudFront, via Origin Access Control, can read objects; the bucket is otherwise private.

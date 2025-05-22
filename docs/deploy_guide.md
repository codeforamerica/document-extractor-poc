# Deploying to a New AWS Account
Based on the files you've shared, here's how to deploy this application to a new AWS account while minimizing costs:

## Prerequisites Setup
1. Ensure you have the following tools installed locally:
  - Python
  - uv (Python package manager)
  - Terraform
  - Node.js
  - AWS CLI (which you mentioned you already have)
2. Configure AWS CLI for your new account:

```shell
aws configure
```

You'll need to enter your AWS access key, secret key, default region (use us-east-1 as shown in the workflow), and output format.

## Deployment Steps
1. Build the Application
First, build both the backend and frontend:

Backend:
```
cd ./backend/
uv sync
uv run build.py
```


This will create backend/dist/lambda.zip.

Frontend:

cd ./ui/
npm ci
npm run build

This will generate files in ui/dist/.

2. Set Up Terraform State Storage
Before running Terraform:

Create an S3 bucket to store the Terraform state:
```shell
aws s3 mb s3://document-extractor-YOUR_ENVIRONMENT-terraform-state
```

Replace YOUR_ENVIRONMENT with your environment name (e.g., dev, prod).

```sh
aws s3 mb s3://document-extractor-dev-terraform-state
```

3. Initialize and Apply Terraform

cd ./iac/
terraform init -backend-config="bucket=document-extractor-YOUR_ENVIRONMENT-terraform-state" -backend-config="key=terraform_state_YOUR_ENVIRONMENT.tfstate"
terraform apply -var 'environment=YOUR_ENVIRONMENT'

```sh
cd ./iac/
terraform init -backend-config="bucket=document-extractor-dev-terraform-state" -backend-config="key=terraform_state_dev.tfstate"
terraform apply -var 'environment=dev'
```


If you need to provide the Textract form adapters environment variables, you'll need to set up that secret value similar to how it's used in the GitHub workflow.

4. Set Up Authentication
After deployment:

Generate RSA key pair
Store the keys and credentials in AWS Secrets Manager:
Private key (PEM format) with "private-key" in the name
Public key (PEM format) with "public-key" in the name
Username with "username" in the name
Hashed password with "password" in the name (generate using the command in the README)
Cost Optimization
To minimize AWS costs:

Choose appropriate Lambda sizing:
Review the Terraform files to ensure Lambda functions aren't overprovisioned
Adjust memory allocation to the minimum needed
S3 Storage:
Consider lifecycle policies for old data
Use the Standard-IA storage class for infrequently accessed data
CloudFront Optimization:
Review caching policies to maximize cache hits
Consider restricting geographic distribution if you don't need global access
Textract Usage:
Be mindful of Textract API calls, as they can accumulate costs
Batch documents when possible to reduce API calls
CloudWatch Logs:
Set appropriate log retention periods
Consider disabling detailed logging in production
Scheduled Cleanup:
Consider setting up cleanup processes for temporary files/data



===
Textract Form Adapters Environment Variables
Yes, the codebase does require the Textract form adapters environment variables. In the variables.tf file, there's a variable defined as textract_form_adapters_env_var_mapping which is used in the lambda.tf file to set environment variables for the text extraction Lambda function. This is marked as sensitive and nullable, so while it's required for full functionality, you might be able to run with an empty map if you're just testing.

Lambda Function Sizes
Currently, all Lambda functions in this application are configured with:

Memory: 256 MB
Timeout: 30 seconds
Architecture: arm64 (AWS Graviton)
Provisioned concurrency: 1 for each Lambda function
The smallest Lambda size AWS offers is 128 MB. For this application:

Text extraction (256 MB): This is reasonable given it's processing documents with OCR
Write to DynamoDB (256 MB): This could potentially run on 128 MB if you're cost-optimizing
Authorizer (256 MB): Could likely run on 128 MB as authentication flows are typically lightweight
I would recommend keeping the text extraction Lambda at 256 MB since it's doing the heavy lifting with Textract, but you could consider reducing the other two to 128 MB if cost is a priority.

Terraform Init Error
The error you're seeing is because you included s3:// in the bucket name. Terraform's S3 backend configuration expects just the bucket name without the protocol prefix:
```sh
terraform init -backend-config="bucket=document-extractor-dev-terraform-state" -backend-config="key=terraform_state_dev.tfstate"
```

State File Path Prompt
When Terraform asks for "The path to the state file inside the bucket", you should enter:

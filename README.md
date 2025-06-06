# Document Extractor Proof of Concept

Public Benefits Studio's Document Extractor to automate document data extraction with AI and OCR.

## Using and Running

Using your browser of choice, navigate to the CloudFront distribution URL to start using.

## Development

### Requirements to Deploy

The requirements needed to deploy are...

- [Python](https://docs.python-guide.org/starting/installation/).
- [uv](https://docs.astral.sh/uv/).
- [Terraform](https://www.terraform.io).
- [Node.js](https://nodejs.org).
- An [AWS](https://aws.amazon.com/) account.

### Deploying

You can mimic the steps in our [Continuous Delivery GitHub Action](.github/workflows/cd.yml).

The basic steps to accomplish this are...
1. Build the backend.
2. Build the frontend.
3. Deploy using the Infrastructure as Code (IaC).

#### Authentication

One username and password is supported currently.  To set this up, do a deployment and then do the following...

1. Generate an RSA private key.  Use the PEM encoding.  Upload it to AWS Secrets Manager with `private-key` in the name.
2. Generate a public key from the aforementioned private key.  Use the PEM encoding.  Upload it to AWS Secrets Manager with `public-key` in the name.
3. Come up with a username you want to use.  Upload it to AWS Secrets Manager with `username` in the name.
4. Come up with a strong password you want to use.  Do not store the plaintext version of the password in AWS Secrets Manager because it is not ideal and doesn't work anyway.  From the `backend` folder, run `echo 'import bcrypt;print(bcrypt.hashpw(b"<your password>", bcrypt.gensalt()).decode())' | uv run -` and replace `<your password>` with the password you want to use.  Upload what is printed out to AWS Secrets Manager with `password` in the name.

### Building

#### Backend

To build the backend, execute...

```shell
cd ./backend/
uv sync
uv run build.py
```

The built artifact is `backend/dist/lambda.zip`.

#### Frontend

To build the frontend, execute...

```shell
cd ./ui/
npm ci
npm run build
```

The built artifact is in `ui/dist/`.

### Additional Requirements to Develop

The additional requirements needed to contribute towards development are...

- [Pre-Commit](https://pre-commit.com).

### Running Locally

#### Frontend
```shell
cd ./ui/
npm install
npm run dev
```
1. Navigate to the UI folder
2. Install dependencies
3. Start the development server

And it runs on http://localhost:1234

#### Known issues and future improvements
- Replace browser system alert messages with user-friendly error handling.
- Improve page transitions for smoother user experience.
- Display the uploaded filename in the UI.

#### Future considerations
- Add frontend unit tests
- As the project grows, consider using USWDS Sass for better CSS organization and customization.

### Pre-Commit Hooks

We use [`pre-commit`](https://pre-commit.com) to run [some hooks](.pre-commit-config.yaml) on every commit.  These
hooks do linting to ensure things are in a good spot before a commit is made.  Please install `pre-commit` and then
install the hooks.

```shell
pre-commit install
```

Most of the time any errors encountered by pre-commit are automatically fixed.  Run `git status` to see the fixed files,
run `git add .` to add the fixes, and rerun the commit.  You will need to manually fix any errors that are not
automatically fixed.

## Troubleshooting

### AWS Secrets Manager

If you're experiencing authentication issues or need to verify that your secrets are properly configured in AWS Secrets Manager, you can use the provided script to list all secrets in your account:

```shell
python scripts/list_aws_secrets.py
```

**Usage Options:**
- `--profile <profile_name>`: Use a specific AWS CLI profile
- `--region <region_name>`: Use a specific AWS region

**Examples:**
```shell
# List secrets using default profile and region
python scripts/list_aws_secrets.py

# List secrets using a specific AWS profile
python scripts/list_aws_secrets.py --profile my-aws-profile

# List secrets in a specific region
python scripts/list_aws_secrets.py --region us-east-1

# Use both custom profile and region
python scripts/list_aws_secrets.py --profile my-aws-profile --region us-west-2
```

This script will show you all secrets (including those pending deletion) and help you verify that the required authentication secrets are present:
- A secret with `private-key` in the name (RSA private key in PEM format)
- A secret with `public-key` in the name (RSA public key in PEM format)
- A secret with `username` in the name (login username)
- A secret with `password` in the name (bcrypt hashed password)

The script outputs both a formatted table and detailed JSON for comprehensive debugging.

### Deleting Authentication Secrets

If you need to delete and recreate the authentication secrets, you can use the provided deletion script. **This script forces permanent deletion with no recovery period** and only allows deletion of the four authentication-related secrets for safety:

```shell
python scripts/delete_aws_secrets.py <secret_name>
```

**Allowed secret names:**
- `private-key`
- `public-key`
- `username`
- `password`

**Usage Options:**
- `--profile <profile_name>`: Use a specific AWS CLI profile
- `--region <region_name>`: Use a specific AWS region
- `--no-force`: Use standard 30-day recovery period instead of immediate deletion
- `--yes`: Skip confirmation prompt (dangerous!)

**Examples:**
```shell
# Delete all secrets containing "private-key" (with confirmation)
python scripts/delete_aws_secrets.py private-key

# Delete using specific profile and region
python scripts/delete_aws_secrets.py username --profile my-aws-profile --region us-east-1

# Delete without force (30-day recovery period)
python scripts/delete_aws_secrets.py password --no-force

# Delete without confirmation (use with extreme caution!)
python scripts/delete_aws_secrets.py public-key --yes
```

**Safety Features:**
- Only allows deletion of hardcoded authentication secret names
- Requires typing "DELETE" (all caps) to confirm
- Shows all matching secrets before deletion
- Provides detailed feedback on success/failure
- Forces permanent deletion by default (ignores retention policies)

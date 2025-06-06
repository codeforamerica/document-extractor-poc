#!/usr/bin/env python3

# builds the backend and the frontend
# pushes both with terraform

import argparse
import os
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).parent.absolute()
BACKEND_DIR = ROOT_DIR / 'backend'
UI_DIR = ROOT_DIR / 'ui'
IAC_DIR = ROOT_DIR / 'iac'

# AWS Profile from memory
# AWS_PROFILE = 'default'
AWS_PROFILE = 'AWSAdministratorAccess-328307993388'

# AWS Region from memory
AWS_REGION = 'us-east-1'

def get_sso_credentials():
    """Get SSO credentials and return as environment variables."""
    print("=== Getting SSO Credentials ===")
    try:
        result = subprocess.run(
            ['aws', 'configure', 'export-credentials', '--profile', AWS_PROFILE, '--format', 'env'],
            capture_output=True,
            text=True,
            check=True
        )

        # Parse the export commands
        credentials = {}
        for line in result.stdout.strip().split('\n'):
            if line.startswith('export '):
                key_value = line.replace('export ', '')
                key, value = key_value.split('=', 1)
                credentials[key] = value

        return credentials
    except subprocess.CalledProcessError as e:
        print(f"Failed to get SSO credentials: {e}")
        print("Please run: aws sso login --profile AWSAdministratorAccess-328307993388")
        sys.exit(1)

def run_command(cmd, cwd=None, env=None, check=True):
    """Run a shell command and return the result."""
    print(f"Running: {' '.join(cmd)}")

    # Merge the current environment with any additional environment variables
    command_env = os.environ.copy()
    if env:
        command_env.update(env)

    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            env=command_env,
            check=check,
            text=True,
            capture_output=True
        )
        print(result.stdout)
        return result
    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code {e.returncode}")
        print(f"STDOUT: {e.stdout}")
        print(f"STDERR: {e.stderr}")
        if check:
            sys.exit(e.returncode)
        return e

def build_backend():
    """Build the backend Lambda package."""
    print("=== Building Backend ===")
    os.chdir(BACKEND_DIR)
    run_command([sys.executable, 'build.py'], cwd=BACKEND_DIR)
    print("Backend build completed successfully!")

def build_frontend():
    """Build the frontend assets."""
    print("=== Building Frontend ===")
    # Make sure node_modules exists
    if not (UI_DIR / 'node_modules').exists():
        run_command(['npm', 'install'], cwd=UI_DIR)

    # Build the frontend
    run_command(['npm', 'run', 'build'], cwd=UI_DIR)
    print("Frontend build completed successfully!")

def terraform_init():
    """Initialize Terraform."""
    print("=== Initializing Terraform ===")
    # Get SSO credentials
    sso_credentials = get_sso_credentials()
    env = {
        'AWS_PROFILE': AWS_PROFILE,
        'AWS_REGION': AWS_REGION,
        **sso_credentials  # Include SSO credentials
    }
    run_command(['terraform', 'init'], cwd=IAC_DIR, env=env)

def terraform_plan():
    """Run Terraform plan."""
    print("=== Running Terraform Plan ===")
    # Get SSO credentials
    sso_credentials = get_sso_credentials()
    env = {
        'AWS_PROFILE': AWS_PROFILE,
        'AWS_REGION': AWS_REGION,
        **sso_credentials  # Include SSO credentials
    }
    run_command(['terraform', 'plan'], cwd=IAC_DIR, env=env)

def terraform_apply():
    """Apply Terraform changes."""
    print("=== Applying Terraform Changes ===")
    # Get SSO credentials
    sso_credentials = get_sso_credentials()
    env = {
        'AWS_PROFILE': AWS_PROFILE,
        'AWS_REGION': AWS_REGION,
        **sso_credentials  # Include SSO credentials
    }
    run_command(['terraform', 'apply', '-auto-approve'], cwd=IAC_DIR, env=env)

def main():
    parser = argparse.ArgumentParser(description='Build and deploy the document extractor application')
    parser.add_argument('--skip-backend', action='store_true', help='Skip backend build')
    parser.add_argument('--skip-frontend', action='store_true', help='Skip frontend build')
    parser.add_argument('--plan-only', action='store_true', help='Only run Terraform plan without applying')
    args = parser.parse_args()

    # Build steps
    if not args.skip_backend:
        build_backend()
    else:
        print("Skipping backend build...")

    if not args.skip_frontend:
        build_frontend()
    else:
        print("Skipping frontend build...")

    # Terraform steps
    terraform_init()

    if args.plan_only:
        terraform_plan()
        print("\nTerraform plan completed. Run without --plan-only to apply the changes.")
    else:
        terraform_apply()
        print("\nDeployment completed successfully!")

if __name__ == '__main__':
    main()

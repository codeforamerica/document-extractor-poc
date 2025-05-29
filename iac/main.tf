terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "AWSAdministratorAccess-328307993388"

  default_tags {
    tags = {
      project = "${local.project}-${var.environment}"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "document-extractor-dev-terraform-state"
    key            = "document-extractor/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks-dev"
    encrypt        = true
    profile        = "AWSAdministratorAccess-328307993388"
  }
}

locals {
  project = "document-extractor"
}

data "aws_caller_identity" "current" {}

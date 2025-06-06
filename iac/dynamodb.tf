resource "aws_dynamodb_table" "extract_table" {
  name     = "${local.project}-${var.environment}-text-extract"
  hash_key = "document_id"

  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "document_id"
    type = "S"
  }

  # Server-side encryption
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.encryption.arn
  }

  # Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Enable deletion protection for production
  deletion_protection_enabled = var.environment == "prod" ? true : false

  tags = {
    Name        = "${local.project}-${var.environment}-text-extract"
    Environment = var.environment
  }
}

# DynamoDB Backup Vault
resource "aws_backup_vault" "dynamodb_backup_vault" {
  name        = "${local.project}-${var.environment}-dynamodb-backup-vault"
  kms_key_arn = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-dynamodb-backup-vault"
  }
}

# IAM Role for AWS Backup
resource "aws_iam_role" "backup_role" {
  name = "${local.project}-${var.environment}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# Backup Plan
resource "aws_backup_plan" "dynamodb_backup_plan" {
  name = "${local.project}-${var.environment}-dynamodb-backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.dynamodb_backup_vault.name
    schedule          = "cron(0 5 ? * * *)"  # Daily at 5 AM UTC

    lifecycle {
      cold_storage_after = 30
      delete_after       = 365  # 1 year retention
    }

    recovery_point_tags = {
      BackupType = "Daily"
    }
  }

  rule {
    rule_name         = "monthly_backup"
    target_vault_name = aws_backup_vault.dynamodb_backup_vault.name
    schedule          = "cron(0 5 1 * ? *)"  # Monthly on the 1st at 5 AM UTC

    lifecycle {
      cold_storage_after = 30
      delete_after       = 2555  # ~7 years retention
    }

    recovery_point_tags = {
      BackupType = "Monthly"
    }
  }
}

# Backup Selection
resource "aws_backup_selection" "dynamodb_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "${local.project}-${var.environment}-dynamodb-backup-selection"
  plan_id      = aws_backup_plan.dynamodb_backup_plan.id

  resources = [
    aws_dynamodb_table.extract_table.arn
  ]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }
}

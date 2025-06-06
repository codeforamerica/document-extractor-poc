resource "aws_kms_key" "encryption" {
  description             = "Data encryption for ${local.project}-${var.environment}"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.kms_key_policy.json

  tags = {
    Name        = "${local.project}-${var.environment}-encryption-key"
    Environment = var.environment
  }
}

# KMS Key Alias
resource "aws_kms_alias" "encryption" {
  name          = "alias/${local.project}-${var.environment}-encryption-key"
  target_key_id = aws_kms_key.encryption.key_id
}

# KMS Key Policy
data "aws_iam_policy_document" "kms_key_policy" {
  # Enable IAM User Permissions
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Allow key usage for AWS services
  statement {
    sid    = "Allow use of the key for AWS services"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "s3.amazonaws.com",
        "lambda.amazonaws.com",
        "dynamodb.amazonaws.com",
        "logs.amazonaws.com",
        "sqs.amazonaws.com",
        "secretsmanager.amazonaws.com",
        "backup.amazonaws.com"
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]

    resources = ["*"]
  }

  # Allow Lambda execution role access
  statement {
    sid    = "Allow Lambda execution role access"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.execution_role.arn]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }
}

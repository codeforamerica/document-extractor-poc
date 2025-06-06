resource "aws_secretsmanager_secret" "private_key" {
  name                    = "${local.project}-${var.environment}-private-key"
  description             = "Private key for ${local.project} ${var.environment}"
  kms_key_id              = aws_kms_key.encryption.arn
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Name        = "${local.project}-${var.environment}-private-key"
    Environment = var.environment
    Type        = "PrivateKey"
  }
}

resource "aws_secretsmanager_secret_policy" "private_key" {
  secret_arn = aws_secretsmanager_secret.private_key.arn
  policy     = data.aws_iam_policy_document.secrets_policy.json
}

resource "aws_secretsmanager_secret" "public_key" {
  name                    = "${local.project}-${var.environment}-public-key"
  description             = "Public key for ${local.project} ${var.environment}"
  kms_key_id              = aws_kms_key.encryption.arn
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Name        = "${local.project}-${var.environment}-public-key"
    Environment = var.environment
    Type        = "PublicKey"
  }
}

resource "aws_secretsmanager_secret_policy" "public_key" {
  secret_arn = aws_secretsmanager_secret.public_key.arn
  policy     = data.aws_iam_policy_document.secrets_policy.json
}

resource "aws_secretsmanager_secret" "username" {
  name                    = "${local.project}-${var.environment}-username"
  description             = "Username for ${local.project} ${var.environment}"
  kms_key_id              = aws_kms_key.encryption.arn
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Name        = "${local.project}-${var.environment}-username"
    Environment = var.environment
    Type        = "Credential"
  }
}

resource "aws_secretsmanager_secret_policy" "username" {
  secret_arn = aws_secretsmanager_secret.username.arn
  policy     = data.aws_iam_policy_document.secrets_policy.json
}

resource "aws_secretsmanager_secret" "password" {
  name                    = "${local.project}-${var.environment}-password"
  description             = "Password for ${local.project} ${var.environment}"
  kms_key_id              = aws_kms_key.encryption.arn
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Name        = "${local.project}-${var.environment}-password"
    Environment = var.environment
    Type        = "Credential"
  }
}

resource "aws_secretsmanager_secret_policy" "password" {
  secret_arn = aws_secretsmanager_secret.password.arn
  policy     = data.aws_iam_policy_document.secrets_policy.json
}

# Secrets Manager Resource Policy
data "aws_iam_policy_document" "secrets_policy" {
  statement {
    sid    = "AllowLambdaAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.execution_role.arn]
    }

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }

  statement {
    sid    = "DenyInsecureConnections"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["secretsmanager:*"]
    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

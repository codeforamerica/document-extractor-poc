resource "aws_s3_bucket" "document_storage" {
  bucket = "${local.project}-${var.environment}-documents-${data.aws_caller_identity.current.account_id}"

  force_destroy = false

  # Object Lock must be enabled at bucket creation
  object_lock_enabled = true
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "document_storage" {
  bucket = aws_s3_bucket.document_storage.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# Versioning configuration
resource "aws_s3_bucket_versioning" "document_storage" {
  bucket = aws_s3_bucket.document_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Object Lock configuration
resource "aws_s3_bucket_object_lock_configuration" "document_storage" {
  bucket = aws_s3_bucket.document_storage.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 90
    }
  }

  depends_on = [aws_s3_bucket_versioning.document_storage]
}

# Public access block
resource "aws_s3_bucket_public_access_block" "document_storage" {
  bucket = aws_s3_bucket.document_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SSL enforcement policy
resource "aws_s3_bucket_policy" "document_storage_ssl" {
  bucket = aws_s3_bucket.document_storage.id
  policy = data.aws_iam_policy_document.document_storage_ssl.json
}

data "aws_iam_policy_document" "document_storage_ssl" {
  statement {
    sid    = "DenyInsecureConnections"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.document_storage.arn,
      "${aws_s3_bucket.document_storage.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_notification" "notify_on_input_data" {
  bucket = aws_s3_bucket.document_storage.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.text_extract.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "input/"
  }

  depends_on = [aws_lambda_permission.allow_bucket_invoke]
}

resource "aws_s3_bucket_lifecycle_configuration" "document_storage_lifecycles" {
  bucket = aws_s3_bucket.document_storage.id

  rule {
    id     = "delete-uploaded-documents"
    status = "Enabled"

    filter {
      prefix = "input/"
    }

    expiration {
      days = 31
    }
  }
}

# S3 Access Logging Bucket
resource "aws_s3_bucket" "access_logs" {
  bucket = "${local.project}-${var.environment}-access-logs-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs_lifecycle" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "delete-access-logs"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Website Storage Bucket
resource "aws_s3_bucket" "website_storage" {
  bucket = "${local.project}-${var.environment}-website-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

# Server-side encryption for website storage
resource "aws_s3_bucket_server_side_encryption_configuration" "website_storage" {
  bucket = aws_s3_bucket.website_storage.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "website_storage_versioning" {
  bucket = aws_s3_bucket.website_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_storage.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

module "read_website_files" {
  source  = "hashicorp/dir/template"
  version = "~> 1.0.2"

  base_dir = "${path.root}/../ui/dist/"
}

resource "aws_s3_object" "website_files" {
  for_each = module.read_website_files.files

  bucket = aws_s3_bucket.website_storage.bucket
  key    = each.key
  source = each.value.source_path

  etag         = each.value.digests.md5
  content_type = each.value.content_type

  tags = {
    project = local.project
  }
}

# Updated Public Access Block: keep public blocked except allow CloudFront
resource "aws_s3_bucket_public_access_block" "private_website" {
  bucket = aws_s3_bucket.website_storage.id

  block_public_acls   = true
  ignore_public_acls  = true
  block_public_policy = true   # stays ON
  restrict_public_buckets = false  # must be false to allow service principal
}

resource "aws_s3_bucket_policy" "website_read" {
  bucket = aws_s3_bucket.website_storage.id
  policy = data.aws_iam_policy_document.cf_read.json
}

# S3 Access Logging Configuration
resource "aws_s3_bucket_logging" "document_storage_logging" {
  bucket = aws_s3_bucket.document_storage.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "document-storage-access-logs/"
}

resource "aws_s3_bucket_logging" "website_storage_logging" {
  bucket = aws_s3_bucket.website_storage.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "website-storage-access-logs/"
}

data "aws_iam_policy_document" "cf_read" {
  # Allow CloudFront access
  statement {
    sid     = "AllowCloudFront"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_storage.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.distribution.arn]
    }
  }

  # Deny insecure connections
  statement {
    sid    = "DenyInsecureConnections"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.website_storage.arn,
      "${aws_s3_bucket.website_storage.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

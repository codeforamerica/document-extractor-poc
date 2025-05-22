resource "aws_s3_bucket" "document_storage" {
  bucket = "${local.project}-${var.environment}-documents-${data.aws_caller_identity.current.account_id}"

  force_destroy = false
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

resource "aws_s3_bucket" "website_storage" {
  bucket = "${local.project}-${var.environment}-website-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
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

data "aws_iam_policy_document" "cf_read" {
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
}

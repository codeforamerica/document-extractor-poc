#!/bin/bash

# Simple script to empty an S3 bucket using AWS CLI
# Usage: ./empty_s3_bucket_simple.sh [bucket-name]

BUCKET_NAME="${1:-document-extractor-dev-documents-328307993388}"

echo "🗑️  Emptying S3 bucket: $BUCKET_NAME"

# Check if bucket exists
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "❌ Bucket $BUCKET_NAME does not exist or you don't have access to it"
    exit 1
fi

echo "🚀 Removing all objects and versions..."

# Remove all objects and versions
aws s3 rm s3://"$BUCKET_NAME" --recursive

# Also remove all versions if versioning is enabled
echo "🔄 Removing all object versions..."
aws s3api delete-objects \
    --bucket "$BUCKET_NAME" \
    --delete "$(aws s3api list-object-versions \
        --bucket "$BUCKET_NAME" \
        --output json \
        --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}, Quiet: true}' 2>/dev/null || echo '{Objects:[], Quiet: true}')"

# Remove delete markers
echo "🗑️  Removing delete markers..."
aws s3api delete-objects \
    --bucket "$BUCKET_NAME" \
    --delete "$(aws s3api list-object-versions \
        --bucket "$BUCKET_NAME" \
        --output json \
        --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}, Quiet: true}' 2>/dev/null || echo '{Objects:[], Quiet: true}')"

echo "✅ Bucket emptying complete!"
echo "🎯 You can now run 'terraform destroy' again"

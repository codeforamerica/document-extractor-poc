#!/bin/bash

# Script to empty an S3 bucket completely
# Usage: ./empty_s3_bucket.sh <bucket-name>

set -e

BUCKET_NAME="${1:-document-extractor-dev-documents-328307993388}"

if [ -z "$BUCKET_NAME" ]; then
    echo "Usage: $0 <bucket-name>"
    echo "Example: $0 document-extractor-dev-documents-328307993388"
    exit 1
fi

echo "🗑️  Emptying S3 bucket: $BUCKET_NAME"

# Check if bucket exists
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "❌ Bucket $BUCKET_NAME does not exist or you don't have access to it"
    exit 1
fi

echo "📋 Checking bucket versioning status..."
VERSIONING=$(aws s3api get-bucket-versioning --bucket "$BUCKET_NAME" --query 'Status' --output text 2>/dev/null || echo "null")
echo "   Versioning status: $VERSIONING"

# Function to delete objects in batches
delete_objects_batch() {
    local version_flag="$1"
    local batch_size=1000

    echo "🔍 Finding objects to delete..."

    while true; do
        # Get objects (with or without versions)
        if [ "$version_flag" = "--versions" ]; then
            objects=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" \
                --query 'Versions[].{Key:Key,VersionId:VersionId}' \
                --max-items $batch_size --output json 2>/dev/null || echo '[]')
        else
            objects=$(aws s3api list-objects-v2 --bucket "$BUCKET_NAME" \
                --query 'Contents[].{Key:Key}' \
                --max-items $batch_size --output json 2>/dev/null || echo '[]')
        fi

        # Check if we got any objects
        object_count=$(echo "$objects" | jq '. | length')

        if [ "$object_count" -eq 0 ]; then
            echo "   No more objects found"
            break
        fi

        echo "   Found $object_count objects to delete"

        # Create delete request
        if [ "$version_flag" = "--versions" ]; then
            delete_request=$(echo "$objects" | jq '{Objects: [.[] | {Key: .Key, VersionId: .VersionId}], Quiet: true}')
        else
            delete_request=$(echo "$objects" | jq '{Objects: [.[] | {Key: .Key}], Quiet: true}')
        fi

        # Write to temp file
        echo "$delete_request" > /tmp/delete_request.json

        # Delete the batch
        echo "   Deleting batch of $object_count objects..."
        aws s3api delete-objects --bucket "$BUCKET_NAME" --delete file:///tmp/delete_request.json > /dev/null

        # If we got less than batch_size, we're done
        if [ "$object_count" -lt $batch_size ]; then
            break
        fi
    done

    # Clean up temp file
    rm -f /tmp/delete_request.json
}

# Function to delete delete markers
delete_delete_markers() {
    echo "🗑️  Deleting delete markers..."

    while true; do
        delete_markers=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" \
            --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' \
            --max-items 1000 --output json 2>/dev/null || echo '[]')

        marker_count=$(echo "$delete_markers" | jq '. | length')

        if [ "$marker_count" -eq 0 ]; then
            echo "   No delete markers found"
            break
        fi

        echo "   Found $marker_count delete markers to remove"

        delete_request=$(echo "$delete_markers" | jq '{Objects: [.[] | {Key: .Key, VersionId: .VersionId}], Quiet: true}')
        echo "$delete_request" > /tmp/delete_markers.json

        aws s3api delete-objects --bucket "$BUCKET_NAME" --delete file:///tmp/delete_markers.json > /dev/null
        echo "   Deleted $marker_count delete markers"

        if [ "$marker_count" -lt 1000 ]; then
            break
        fi
    done

    rm -f /tmp/delete_markers.json
}

echo ""
echo "🚀 Starting bucket cleanup..."

# If versioning is enabled, we need to handle versions and delete markers
if [ "$VERSIONING" = "Enabled" ] || [ "$VERSIONING" = "Suspended" ]; then
    echo ""
    echo "📦 Deleting all object versions..."
    delete_objects_batch "--versions"

    echo ""
    delete_delete_markers
fi

echo ""
echo "📄 Deleting current objects..."
delete_objects_batch

echo ""
echo "🔍 Final verification..."
remaining_objects=$(aws s3api list-objects-v2 --bucket "$BUCKET_NAME" --query 'Contents | length(@)' --output text 2>/dev/null || echo "0")
remaining_versions=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --query 'Versions | length(@)' --output text 2>/dev/null || echo "0")
remaining_markers=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --query 'DeleteMarkers | length(@)' --output text 2>/dev/null || echo "0")

echo "   Objects: $remaining_objects"
echo "   Versions: $remaining_versions"
echo "   Delete markers: $remaining_markers"

if [ "$remaining_objects" = "0" ] && [ "$remaining_versions" = "0" ] && [ "$remaining_markers" = "0" ]; then
    echo ""
    echo "✅ Bucket $BUCKET_NAME is now empty!"
    echo "🎯 You can now run 'terraform destroy' again"
else
    echo ""
    echo "⚠️  Warning: Bucket may not be completely empty"
    echo "   You may need to check for incomplete multipart uploads or run this script again"
fi

echo ""
echo "🏁 Done!"

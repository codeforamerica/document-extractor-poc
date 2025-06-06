output "distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# Security Outputs
output "kms_key_id" {
  description = "ID of the KMS encryption key"
  value       = aws_kms_key.encryption.key_id
}

output "kms_key_alias" {
  description = "Alias of the KMS encryption key"
  value       = aws_kms_alias.encryption.name
}

# Monitoring Outputs
output "cloudwatch_dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

# S3 Outputs
output "document_storage_bucket" {
  description = "Name of the document storage bucket"
  value       = aws_s3_bucket.document_storage.bucket
}

output "access_logs_bucket" {
  description = "Name of the access logs bucket"
  value       = aws_s3_bucket.access_logs.bucket
}

# API Gateway Output
output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = aws_api_gateway_stage.stage.invoke_url
}

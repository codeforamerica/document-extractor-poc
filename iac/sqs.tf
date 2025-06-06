# Main SQS Queue DLQ
resource "aws_sqs_queue" "queue_to_dynamo_dlq" {
  name                      = "${local.project}-${var.environment}-to-dynamodb-dlq"
  kms_master_key_id         = aws_kms_key.encryption.id
  message_retention_seconds = 1209600  # 14 days

  tags = {
    Name = "${local.project}-${var.environment}-to-dynamodb-dlq"
  }
}

# Main SQS Queue
resource "aws_sqs_queue" "queue_to_dynamo" {
  name                      = "${local.project}-${var.environment}-to-dynamodb"
  kms_master_key_id         = aws_kms_key.encryption.id
  visibility_timeout_seconds = 60  # 2x Lambda timeout
  message_retention_seconds = 345600  # 4 days

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.queue_to_dynamo_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "${local.project}-${var.environment}-to-dynamodb"
  }
}

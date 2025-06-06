locals {
  lambda_filename         = "${path.module}/../backend/dist/lambda.zip"
  lambda_source_code_hash = filebase64sha256(local.lambda_filename)
  textract_environment_variables = merge(var.textract_form_adapters_env_var_mapping, {
    SQS_QUEUE_URL = aws_sqs_queue.queue_to_dynamo.url
  })
}

resource "aws_lambda_function" "text_extract" {
  function_name = "${local.project}-${var.environment}-text-extract"

  filename         = local.lambda_filename
  source_code_hash = local.lambda_source_code_hash

  handler = "src.external.aws.lambdas.text_extractor.lambda_handler"

  memory_size                    = 256
  timeout                        = 30
  runtime                        = "python3.13"
  reserved_concurrent_executions = 10  # Set reasonable limit instead of unlimited
  publish                        = true

  architectures = ["arm64"]

  kms_key_arn = aws_kms_key.encryption.arn

  role = aws_iam_role.execution_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.text_extract_dlq.arn
  }

  environment {
    variables = local.textract_environment_variables
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_vpc_execution
  ]
}

resource "aws_lambda_permission" "allow_bucket_invoke" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.text_extract.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.document_storage.arn
}

resource "aws_lambda_provisioned_concurrency_config" "text_extract_concurrency" {
  function_name                     = aws_lambda_function.text_extract.function_name
  provisioned_concurrent_executions = 1
  qualifier                         = aws_lambda_function.text_extract.version
}

resource "aws_lambda_function" "write_to_dynamodb" {
  function_name = "${local.project}-${var.environment}-write-to-dynamodb"

  filename         = local.lambda_filename
  source_code_hash = local.lambda_source_code_hash

  handler = "src.external.aws.lambdas.sqs_dynamo_writer.lambda_handler"

  memory_size                    = 256
  timeout                        = 30
  runtime                        = "python3.13"
  reserved_concurrent_executions = 10  # Set reasonable limit instead of unlimited
  publish                        = true

  architectures = ["arm64"]

  kms_key_arn = aws_kms_key.encryption.arn

  role = aws_iam_role.execution_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.write_to_dynamodb_dlq.arn
  }

  environment {
    variables = {
      SQS_QUEUE_URL  = aws_sqs_queue.queue_to_dynamo.url
      DYNAMODB_TABLE = aws_dynamodb_table.extract_table.name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_vpc_execution
  ]
}

resource "aws_lambda_event_source_mapping" "invoke_dynamodb_writer_from_sqs" {
  event_source_arn                   = aws_sqs_queue.queue_to_dynamo.arn
  function_name                      = aws_lambda_function.write_to_dynamodb.arn
  maximum_batching_window_in_seconds = 0

  depends_on = [aws_iam_role_policy_attachment.attach_sqs_permission_to_role]
}

resource "aws_lambda_provisioned_concurrency_config" "write_to_dynamodb_concurrency" {
  function_name                     = aws_lambda_function.write_to_dynamodb.function_name
  provisioned_concurrent_executions = 1
  qualifier                         = aws_lambda_function.write_to_dynamodb.version
}

resource "aws_lambda_function" "authorizer" {
  function_name = "${local.project}-${var.environment}-authorizer"

  filename         = local.lambda_filename
  source_code_hash = local.lambda_source_code_hash

  handler = "src.external.aws.lambdas.authenticate.lambda_handler"

  memory_size                    = 256
  timeout                        = 30
  runtime                        = "python3.13"
  reserved_concurrent_executions = 10  # Set reasonable limit instead of unlimited
  publish                        = true

  architectures = ["arm64"]

  kms_key_arn = aws_kms_key.encryption.arn

  role = aws_iam_role.execution_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.authorizer_dlq.arn
  }

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_vpc_execution
  ]
}

resource "aws_lambda_permission" "api_gateway_invoke_authorizer" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_provisioned_concurrency_config" "authorizer_concurrency" {
  function_name                     = aws_lambda_function.authorizer.function_name
  provisioned_concurrent_executions = 1
  qualifier                         = aws_lambda_function.authorizer.version
}

# CloudWatch Log Groups for Lambda Functions
resource "aws_cloudwatch_log_group" "lambda_text_extract" {
  name              = "/aws/lambda/${local.project}-${var.environment}-text-extract"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-text-extract-logs"
  }
}

resource "aws_cloudwatch_log_group" "lambda_write_to_dynamodb" {
  name              = "/aws/lambda/${local.project}-${var.environment}-write-to-dynamodb"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-write-to-dynamodb-logs"
  }
}

resource "aws_cloudwatch_log_group" "lambda_authorizer" {
  name              = "/aws/lambda/${local.project}-${var.environment}-authorizer"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-authorizer-logs"
  }
}

# Dead Letter Queues for Lambda Functions
resource "aws_sqs_queue" "text_extract_dlq" {
  name                      = "${local.project}-${var.environment}-text-extract-dlq"
  kms_master_key_id         = aws_kms_key.encryption.arn
  message_retention_seconds = 1209600  # 14 days

  tags = {
    Name = "${local.project}-${var.environment}-text-extract-dlq"
  }
}

resource "aws_sqs_queue" "write_to_dynamodb_dlq" {
  name                      = "${local.project}-${var.environment}-write-to-dynamodb-dlq"
  kms_master_key_id         = aws_kms_key.encryption.arn
  message_retention_seconds = 1209600  # 14 days

  tags = {
    Name = "${local.project}-${var.environment}-write-to-dynamodb-dlq"
  }
}

resource "aws_sqs_queue" "authorizer_dlq" {
  name                      = "${local.project}-${var.environment}-authorizer-dlq"
  kms_master_key_id         = aws_kms_key.encryption.arn
  message_retention_seconds = 1209600  # 14 days

  tags = {
    Name = "${local.project}-${var.environment}-authorizer-dlq"
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${local.project}-${var.environment}-api"
  description = "${local.project} API"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment_for_document    = module.document_endpoints.resource_method_integration_configuration_hash
    redeployment_for_document_id = module.document_id_endpoints.resource_method_integration_configuration_hash
  }

  lifecycle {
    create_before_destroy = true
  }
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/v1"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-api-gateway-logs"
  }
}

# CloudWatch Log Group for API Gateway Access Logs
resource "aws_cloudwatch_log_group" "api_gateway_access_logs" {
  name              = "/aws/apigateway/${local.project}-${var.environment}-access-logs"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-api-gateway-access-logs"
  }
}

# API Gateway Account (required for CloudWatch logging)
resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch.arn
}

# IAM Role for API Gateway CloudWatch
resource "aws_iam_role" "api_gateway_cloudwatch" {
  name = "${local.project}-${var.environment}-api-gateway-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy Attachment for API Gateway CloudWatch
resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch" {
  role       = aws_iam_role.api_gateway_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "v1"
  deployment_id = aws_api_gateway_deployment.api_deployment.id

  # Enable X-Ray tracing
  xray_tracing_enabled = true

  # Access logging configuration
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_access_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      extendedRequestId = "$context.extendedRequestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      error_message  = "$context.error.message"
      error_message_string = "$context.error.messageString"
    })
  }

  depends_on = [aws_api_gateway_account.api_gateway_account]
}

# Method Settings for execution logging
resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch metrics
    metrics_enabled = true

    # Enable execution logging
    logging_level      = "INFO"
    data_trace_enabled = true

    # Throttling settings
    throttling_rate_limit  = 100
    throttling_burst_limit = 200
  }
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name                             = "${local.project}-${var.environment}-authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  authorizer_uri                   = aws_lambda_function.authorizer.invoke_arn
  authorizer_result_ttl_in_seconds = 300
}

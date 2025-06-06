# AWS Security Hub
resource "aws_securityhub_account" "main" {
  enable_default_standards = true
}

# Enable Security Hub Standards
resource "aws_securityhub_standards_subscription" "aws_foundational" {
  standards_arn = "arn:aws:securityhub:::ruleset/finding-format/aws-foundational-security-standard/v/1.0.0"
  depends_on    = [aws_securityhub_account.main]
}

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:::ruleset/finding-format/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.main]
}

# CloudWatch Alarms for Cost Monitoring
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  count = var.environment == "prod" ? 1 : 0

  alarm_name          = "${local.project}-${var.environment}-billing-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400"  # 24 hours
  statistic           = "Maximum"
  threshold           = "100"    # $100 threshold
  alarm_description   = "This metric monitors aws billing"
  alarm_actions       = [aws_sns_topic.alerts[0].arn]

  dimensions = {
    Currency = "USD"
  }

  tags = {
    Name = "${local.project}-${var.environment}-billing-alarm"
  }
}

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  count = var.environment == "prod" ? 1 : 0

  name              = "${local.project}-${var.environment}-alerts"
  kms_master_key_id = aws_kms_key.encryption.arn

  tags = {
    Name = "${local.project}-${var.environment}-alerts"
  }
}

# CloudWatch Alarms for Lambda Functions
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  for_each = {
    text_extract       = aws_lambda_function.text_extract.function_name
    write_to_dynamodb  = aws_lambda_function.write_to_dynamodb.function_name
    authorizer         = aws_lambda_function.authorizer.function_name
  }

  alarm_name          = "${each.key}-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors lambda errors for ${each.key}"

  dimensions = {
    FunctionName = each.value
  }

  tags = {
    Name = "${each.key}-errors-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  for_each = {
    text_extract       = aws_lambda_function.text_extract.function_name
    write_to_dynamodb  = aws_lambda_function.write_to_dynamodb.function_name
    authorizer         = aws_lambda_function.authorizer.function_name
  }

  alarm_name          = "${each.key}-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = "25000"  # 25 seconds (near timeout)
  alarm_description   = "This metric monitors lambda duration for ${each.key}"

  dimensions = {
    FunctionName = each.value
  }

  tags = {
    Name = "${each.key}-duration-alarm"
  }
}

# CloudWatch Alarms for API Gateway
resource "aws_cloudwatch_metric_alarm" "api_gateway_4xx_errors" {
  alarm_name          = "${local.project}-${var.environment}-api-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors API Gateway 4XX errors"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.api.name
    Stage   = aws_api_gateway_stage.stage.stage_name
  }

  tags = {
    Name = "${local.project}-${var.environment}-api-4xx-errors"
  }
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_errors" {
  alarm_name          = "${local.project}-${var.environment}-api-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "This metric monitors API Gateway 5XX errors"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.api.name
    Stage   = aws_api_gateway_stage.stage.stage_name
  }

  tags = {
    Name = "${local.project}-${var.environment}-api-5xx-errors"
  }
}

# CloudWatch Alarms for DynamoDB
resource "aws_cloudwatch_metric_alarm" "dynamodb_throttled_requests" {
  alarm_name          = "${local.project}-${var.environment}-dynamodb-throttled-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This metric monitors DynamoDB throttled requests"

  dimensions = {
    TableName = aws_dynamodb_table.extract_table.name
  }

  tags = {
    Name = "${local.project}-${var.environment}-dynamodb-throttled-requests"
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.project}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", aws_lambda_function.text_extract.function_name],
            [".", "Errors", ".", "."],
            [".", "Invocations", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Lambda Metrics - Text Extract"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiName", aws_api_gateway_rest_api.api.name],
            [".", "4XXError", ".", "."],
            [".", "5XXError", ".", "."],
            [".", "Latency", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "API Gateway Metrics"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", aws_dynamodb_table.extract_table.name],
            [".", "ConsumedWriteCapacityUnits", ".", "."],
            [".", "ThrottledRequests", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "DynamoDB Metrics"
          period  = 300
        }
      }
    ]
  })
}

# Cost Anomaly Detection
# Note: AWS Cost Explorer anomaly detection resources are not yet available in Terraform/OpenTofu
# Configure these manually in the AWS Console:
# 1. Go to AWS Cost Management > Cost Anomaly Detection
# 2. Create anomaly detector for services: S3, Lambda, DynamoDB, API Gateway
# 3. Set up email notifications with $100 threshold
# 4. Enable daily frequency for alerts

# Future: Replace with Terraform resources when available
# Tracking: https://github.com/hashicorp/terraform-provider-aws/issues/17200

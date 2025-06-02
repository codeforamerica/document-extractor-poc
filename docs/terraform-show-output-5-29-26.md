# data.aws_caller_identity.current:
data "aws_caller_identity" "current" {
    account_id = "328307993388"
    arn        = "arn:aws:sts::328307993388:assumed-role/AWSReservedSSO_AWSAdministratorAccess_6c478552c0a41d82/hmelo@codeforamerica.org"
    id         = "328307993388"
    user_id    = "AROAUY4FONMWHGL6OXPD2:hmelo@codeforamerica.org"
}

# data.aws_iam_policy.lambda_basic_execution:
data "aws_iam_policy" "lambda_basic_execution" {
    arn              = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    attachment_count = 4
    description      = "Provides write permissions to CloudWatch Logs."
    id               = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    name             = "AWSLambdaBasicExecutionRole"
    path             = "/service-role/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAJNCQGXC42545SKXIK"
    tags             = {}
}

# data.aws_iam_policy.lambda_textract_execution:
data "aws_iam_policy" "lambda_textract_execution" {
    arn              = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
    attachment_count = 1
    description      = "Access to all Amazon Textract APIs"
    id               = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
    name             = "AmazonTextractFullAccess"
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "textract:*",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAIQDD47A7H3GBVPWOQ"
    tags             = {}
}

# data.aws_iam_policy_document.assume_role:
data "aws_iam_policy_document" "assume_role" {
    id            = "2690255455"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "sts:AssumeRole",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = []

        principals {
            identifiers = [
                "lambda.amazonaws.com",
            ]
            type        = "Service"
        }
    }
}

# data.aws_iam_policy_document.cf_read:
data "aws_iam_policy_document" "cf_read" {
    id            = "3877928146"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action    = "s3:GetObject"
                    Condition = {
                        StringEquals = {
                            "AWS:SourceArn" = "arn:aws:cloudfront::328307993388:distribution/ENWTZLUASCDJZ"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Service = "cloudfront.amazonaws.com"
                    }
                    Resource  = "arn:aws:s3:::document-extractor-dev-website-328307993388/*"
                    Sid       = "AllowCloudFront"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action    = "s3:GetObject"
                    Condition = {
                        StringEquals = {
                            "AWS:SourceArn" = "arn:aws:cloudfront::328307993388:distribution/ENWTZLUASCDJZ"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Service = "cloudfront.amazonaws.com"
                    }
                    Resource  = "arn:aws:s3:::document-extractor-dev-website-328307993388/*"
                    Sid       = "AllowCloudFront"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "s3:GetObject",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = [
            "arn:aws:s3:::document-extractor-dev-website-328307993388/*",
        ]
        sid           = "AllowCloudFront"

        condition {
            test     = "StringEquals"
            values   = [
                "arn:aws:cloudfront::328307993388:distribution/ENWTZLUASCDJZ",
            ]
            variable = "AWS:SourceArn"
        }

        principals {
            identifiers = [
                "cloudfront.amazonaws.com",
            ]
            type        = "Service"
        }
    }
}

# data.aws_iam_policy_document.dynamodb_lambda_policy:
data "aws_iam_policy_document" "dynamodb_lambda_policy" {
    id            = "2781330629"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action   = "dynamodb:*"
                    Effect   = "Allow"
                    Resource = "arn:aws:dynamodb:us-west-1:328307993388:table/document-extractor-dev-text-extract"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action   = "dynamodb:*"
                    Effect   = "Allow"
                    Resource = "arn:aws:dynamodb:us-west-1:328307993388:table/document-extractor-dev-text-extract"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "dynamodb:*",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = [
            "arn:aws:dynamodb:us-west-1:328307993388:table/document-extractor-dev-text-extract",
        ]
    }
}

# data.aws_iam_policy_document.kms_lambda_policy:
data "aws_iam_policy_document" "kms_lambda_policy" {
    id            = "2825613304"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "kms:GenerateDataKey",
                        "kms:Encrypt",
                        "kms:DescribeKey",
                        "kms:Decrypt",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "kms:GenerateDataKey",
                        "kms:Encrypt",
                        "kms:DescribeKey",
                        "kms:Decrypt",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "kms:Decrypt",
            "kms:DescribeKey",
            "kms:Encrypt",
            "kms:GenerateDataKey",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = [
            "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c",
        ]
    }
}

# data.aws_iam_policy_document.s3_lambda_policy:
data "aws_iam_policy_document" "s3_lambda_policy" {
    id            = "1929687036"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action   = "s3:*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::document-extractor-dev-documents-328307993388/*",
                        "arn:aws:s3:::document-extractor-dev-documents-328307993388",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action   = "s3:*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::document-extractor-dev-documents-328307993388/*",
                        "arn:aws:s3:::document-extractor-dev-documents-328307993388",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "s3:*",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = [
            "arn:aws:s3:::document-extractor-dev-documents-328307993388",
            "arn:aws:s3:::document-extractor-dev-documents-328307993388/*",
        ]
    }
}

# data.aws_iam_policy_document.secrets_lambda_policy:
data "aws_iam_policy_document" "secrets_lambda_policy" {
    id            = "2856285183"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action   = "secretsmanager:*"
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action   = "secretsmanager:*"
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "secretsmanager:*",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = [
            "*",
        ]
    }
}

# data.aws_iam_policy_document.sqs_lambda_policy:
data "aws_iam_policy_document" "sqs_lambda_policy" {
    id            = "1807487604"
    json          = jsonencode(
        {
            Statement = [
                {
                    Action   = "sqs:*"
                    Effect   = "Allow"
                    Resource = "arn:aws:sqs:us-west-1:328307993388:document-extractor-dev-to-dynamodb"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    minified_json = jsonencode(
        {
            Statement = [
                {
                    Action   = "sqs:*"
                    Effect   = "Allow"
                    Resource = "arn:aws:sqs:us-west-1:328307993388:document-extractor-dev-to-dynamodb"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    version       = "2012-10-17"

    statement {
        actions       = [
            "sqs:*",
        ]
        effect        = "Allow"
        not_actions   = []
        not_resources = []
        resources     = [
            "arn:aws:sqs:us-west-1:328307993388:document-extractor-dev-to-dynamodb",
        ]
    }
}

# aws_api_gateway_authorizer.authorizer:
resource "aws_api_gateway_authorizer" "authorizer" {
    arn                              = "arn:aws:apigateway:us-west-1::/restapis/ic9avcgf3l/authorizers/bq0hho"
    authorizer_result_ttl_in_seconds = 300
    authorizer_uri                   = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-authorizer/invocations"
    id                               = "bq0hho"
    identity_source                  = "method.request.header.Authorization"
    name                             = "document-extractor-dev-authorizer"
    provider_arns                    = []
    rest_api_id                      = "ic9avcgf3l"
    type                             = "TOKEN"
}

# aws_api_gateway_deployment.api_deployment:
resource "aws_api_gateway_deployment" "api_deployment" {
    created_date  = "2025-05-22T17:09:14Z"
    execution_arn = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/"
    id            = "ag6ofm"
    invoke_url    = "https://ic9avcgf3l.execute-api.us-west-1.amazonaws.com/"
    rest_api_id   = "ic9avcgf3l"
    triggers      = {
        "redeployment_for_document"    = "df368280881120978a4c4656300fde0f324b8281bf99d7ba054eec9cc8bd6211f4e79278474c2d01aea853b44799e445dcaa6b21affb76afc9f42daabaa1b1f2"
        "redeployment_for_document_id" = "7dba33f74bbc4cd4db523d3160e633446810ebc4a2940bb1e800d0aafb37327407f2bd45b4e7eae6cd0fb5cf2b12ad4c605c11baf1ea64ee14f72c04ca4a4abf"
    }
}

# aws_api_gateway_rest_api.api:
resource "aws_api_gateway_rest_api" "api" {
    api_key_source               = "HEADER"
    arn                          = "arn:aws:apigateway:us-west-1::/restapis/ic9avcgf3l"
    binary_media_types           = []
    created_date                 = "2025-05-22T15:30:42Z"
    description                  = "document-extractor API"
    disable_execute_api_endpoint = false
    execution_arn                = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l"
    id                           = "ic9avcgf3l"
    name                         = "document-extractor-dev-api"
    root_resource_id             = "qdlfjof80i"
    tags                         = {}
    tags_all                     = {
        "project" = "document-extractor-dev"
    }

    endpoint_configuration {
        ip_address_type  = "ipv4"
        types            = [
            "EDGE",
        ]
        vpc_endpoint_ids = []
    }
}

# aws_api_gateway_stage.stage:
resource "aws_api_gateway_stage" "stage" {
    arn                   = "arn:aws:apigateway:us-west-1::/restapis/ic9avcgf3l/stages/v1"
    cache_cluster_enabled = false
    deployment_id         = "ag6ofm"
    execution_arn         = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/v1"
    id                    = "ags-ic9avcgf3l-v1"
    invoke_url            = "https://ic9avcgf3l.execute-api.us-west-1.amazonaws.com/v1"
    rest_api_id           = "ic9avcgf3l"
    stage_name            = "v1"
    tags                  = {}
    tags_all              = {
        "project" = "document-extractor-dev"
    }
    variables             = {}
    xray_tracing_enabled  = false
}

# aws_cloudfront_distribution.distribution:
resource "aws_cloudfront_distribution" "distribution" {
    aliases                        = []
    arn                            = "arn:aws:cloudfront::328307993388:distribution/ENWTZLUASCDJZ"
    caller_reference               = "terraform-2025052215335454220000000c"
    comment                        = "document-extractor dev website"
    default_root_object            = "index.html"
    domain_name                    = "d1phjy5x6ttml2.cloudfront.net"
    enabled                        = true
    etag                           = "E4X7Q0PHSPAIJ"
    hosted_zone_id                 = "Z2FDTNDATAQYW2"
    http_version                   = "http2"
    id                             = "ENWTZLUASCDJZ"
    in_progress_validation_batches = 0
    is_ipv6_enabled                = true
    last_modified_time             = "2025-05-22 17:11:46.344 +0000 UTC"
    price_class                    = "PriceClass_100"
    retain_on_delete               = false
    staging                        = false
    status                         = "Deployed"
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    trusted_key_groups             = [
        {
            enabled = false
            items   = []
        },
    ]
    trusted_signers                = [
        {
            enabled = false
            items   = []
        },
    ]
    wait_for_deployment            = true

    default_cache_behavior {
        allowed_methods        = [
            "GET",
            "HEAD",
        ]
        cached_methods         = [
            "GET",
            "HEAD",
        ]
        compress               = true
        default_ttl            = 86400
        max_ttl                = 172800
        min_ttl                = 0
        smooth_streaming       = false
        target_origin_id       = "website-in-s3"
        trusted_key_groups     = []
        trusted_signers        = []
        viewer_protocol_policy = "redirect-to-https"

        forwarded_values {
            headers                 = []
            query_string            = false
            query_string_cache_keys = []

            cookies {
                forward           = "none"
                whitelisted_names = []
            }
        }

        grpc_config {
            enabled = false
        }
    }

    ordered_cache_behavior {
        allowed_methods          = [
            "DELETE",
            "GET",
            "HEAD",
            "OPTIONS",
            "PATCH",
            "POST",
            "PUT",
        ]
        cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
        cached_methods           = [
            "GET",
            "HEAD",
        ]
        compress                 = true
        default_ttl              = 0
        max_ttl                  = 0
        min_ttl                  = 0
        origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
        path_pattern             = "/api/*"
        smooth_streaming         = false
        target_origin_id         = "api-in-gateway"
        trusted_key_groups       = []
        trusted_signers          = []
        viewer_protocol_policy   = "redirect-to-https"

        function_association {
            event_type   = "viewer-request"
            function_arn = "arn:aws:cloudfront::328307993388:function/document-extractor-dev-rewrite-request"
        }

        grpc_config {
            enabled = false
        }
    }

    origin {
        connection_attempts = 3
        connection_timeout  = 10
        domain_name         = "ic9avcgf3l.execute-api.us-west-1.amazonaws.com"
        origin_id           = "api-in-gateway"
        origin_path         = "/v1"

        custom_origin_config {
            http_port                = 80
            https_port               = 443
            origin_keepalive_timeout = 5
            origin_protocol_policy   = "https-only"
            origin_read_timeout      = 30
            origin_ssl_protocols     = [
                "TLSv1.2",
            ]
        }
    }
    origin {
        connection_attempts      = 3
        connection_timeout       = 10
        domain_name              = "document-extractor-dev-website-328307993388.s3.us-west-1.amazonaws.com"
        origin_access_control_id = "E5E4NY4IQRCTR"
        origin_id                = "website-in-s3"
    }

    restrictions {
        geo_restriction {
            locations        = []
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
        minimum_protocol_version       = "TLSv1"
    }
}

# aws_cloudfront_function.rewrite_uri:
resource "aws_cloudfront_function" "rewrite_uri" {
    arn                          = "arn:aws:cloudfront::328307993388:function/document-extractor-dev-rewrite-request"
    code                         = <<-EOT
        function handler(event) {
        	var request = event.request;
        	request.uri = request.uri.replace(/^\/api\//, "/");
        	return request;
        }
    EOT
    etag                         = "ETVPDKIKX0DER"
    id                           = "document-extractor-dev-rewrite-request"
    key_value_store_associations = []
    live_stage_etag              = "ETVPDKIKX0DER"
    name                         = "document-extractor-dev-rewrite-request"
    publish                      = true
    runtime                      = "cloudfront-js-1.0"
    status                       = "DEPLOYED"
}

# aws_cloudfront_origin_access_control.oac:
resource "aws_cloudfront_origin_access_control" "oac" {
    arn                               = "arn:aws:cloudfront::328307993388:origin-access-control/E5E4NY4IQRCTR"
    description                       = "SigV4 control for private S3 website bucket"
    etag                              = "ETVPDKIKX0DER"
    id                                = "E5E4NY4IQRCTR"
    name                              = "document-extractor-dev-oac"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

# aws_dynamodb_table.extract_table:
resource "aws_dynamodb_table" "extract_table" {
    arn                         = "arn:aws:dynamodb:us-west-1:328307993388:table/document-extractor-dev-text-extract"
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = false
    hash_key                    = "document_id"
    id                          = "document-extractor-dev-text-extract"
    name                        = "document-extractor-dev-text-extract"
    read_capacity               = 0
    stream_enabled              = false
    table_class                 = "STANDARD"
    tags                        = {}
    tags_all                    = {
        "project" = "document-extractor-dev"
    }
    write_capacity              = 0

    attribute {
        name = "document_id"
        type = "S"
    }

    point_in_time_recovery {
        enabled                 = false
        recovery_period_in_days = 0
    }

    ttl {
        enabled = false
    }
}

# aws_iam_policy.dynamodb_lambda_policy:
resource "aws_iam_policy" "dynamodb_lambda_policy" {
    arn              = "arn:aws:iam::328307993388:policy/document-extractor-dev-dynamodb-lambda-policy"
    attachment_count = 1
    id               = "arn:aws:iam::328307993388:policy/document-extractor-dev-dynamodb-lambda-policy"
    name             = "document-extractor-dev-dynamodb-lambda-policy"
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = "dynamodb:*"
                    Effect   = "Allow"
                    Resource = "arn:aws:dynamodb:us-west-1:328307993388:table/document-extractor-dev-text-extract"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAUY4FONMWOXCPMFZOI"
    tags             = {}
    tags_all         = {
        "project" = "document-extractor-dev"
    }
}

# aws_iam_policy.kms_lambda_policy:
resource "aws_iam_policy" "kms_lambda_policy" {
    arn              = "arn:aws:iam::328307993388:policy/document-extractor-dev-kms-lambda-policy"
    attachment_count = 1
    id               = "arn:aws:iam::328307993388:policy/document-extractor-dev-kms-lambda-policy"
    name             = "document-extractor-dev-kms-lambda-policy"
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "kms:GenerateDataKey",
                        "kms:Encrypt",
                        "kms:DescribeKey",
                        "kms:Decrypt",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAUY4FONMWP3RCSG7LS"
    tags             = {}
    tags_all         = {
        "project" = "document-extractor-dev"
    }
}

# aws_iam_policy.s3_lambda_policy:
resource "aws_iam_policy" "s3_lambda_policy" {
    arn              = "arn:aws:iam::328307993388:policy/document-extractor-dev-s3-lambda-policy"
    attachment_count = 1
    id               = "arn:aws:iam::328307993388:policy/document-extractor-dev-s3-lambda-policy"
    name             = "document-extractor-dev-s3-lambda-policy"
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = "s3:*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::document-extractor-dev-documents-328307993388/*",
                        "arn:aws:s3:::document-extractor-dev-documents-328307993388",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAUY4FONMWEETR66RD5"
    tags             = {}
    tags_all         = {
        "project" = "document-extractor-dev"
    }
}

# aws_iam_policy.secrets_lambda_policy:
resource "aws_iam_policy" "secrets_lambda_policy" {
    arn              = "arn:aws:iam::328307993388:policy/document-extractor-dev-secrets-lambda-policy"
    attachment_count = 1
    id               = "arn:aws:iam::328307993388:policy/document-extractor-dev-secrets-lambda-policy"
    name             = "document-extractor-dev-secrets-lambda-policy"
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = "secretsmanager:*"
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAUY4FONMWH65CVSXAG"
    tags             = {}
    tags_all         = {
        "project" = "document-extractor-dev"
    }
}

# aws_iam_policy.sqs_lambda_policy:
resource "aws_iam_policy" "sqs_lambda_policy" {
    arn              = "arn:aws:iam::328307993388:policy/document-extractor-dev-sqs-lambda-policy"
    attachment_count = 1
    id               = "arn:aws:iam::328307993388:policy/document-extractor-dev-sqs-lambda-policy"
    name             = "document-extractor-dev-sqs-lambda-policy"
    path             = "/"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = "sqs:*"
                    Effect   = "Allow"
                    Resource = "arn:aws:sqs:us-west-1:328307993388:document-extractor-dev-to-dynamodb"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    policy_id        = "ANPAUY4FONMWOGMGQ5D3P"
    tags             = {}
    tags_all         = {
        "project" = "document-extractor-dev"
    }
}

# aws_iam_role.execution_role:
resource "aws_iam_role" "execution_role" {
    arn                   = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    create_date           = "2025-05-22T15:30:43Z"
    force_detach_policies = false
    id                    = "document-extractor-dev-lambda-execution-role"
    managed_policy_arns   = [
        "arn:aws:iam::328307993388:policy/document-extractor-dev-dynamodb-lambda-policy",
        "arn:aws:iam::328307993388:policy/document-extractor-dev-kms-lambda-policy",
        "arn:aws:iam::328307993388:policy/document-extractor-dev-s3-lambda-policy",
        "arn:aws:iam::328307993388:policy/document-extractor-dev-secrets-lambda-policy",
        "arn:aws:iam::328307993388:policy/document-extractor-dev-sqs-lambda-policy",
        "arn:aws:iam::aws:policy/AmazonTextractFullAccess",
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    ]
    max_session_duration  = 3600
    name                  = "document-extractor-dev-lambda-execution-role"
    path                  = "/"
    tags                  = {}
    tags_all              = {
        "project" = "document-extractor-dev"
    }
    unique_id             = "AROAUY4FONMWAAHANRCKS"
}

# aws_iam_role_policy_attachment.attach_basic_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_basic_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-20250522153044909700000007"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_iam_role_policy_attachment.attach_dynamodb_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_dynamodb_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-20250522153115634300000009"
    policy_arn = "arn:aws:iam::328307993388:policy/document-extractor-dev-dynamodb-lambda-policy"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_iam_role_policy_attachment.attach_kms_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_kms_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-2025052215311566550000000a"
    policy_arn = "arn:aws:iam::328307993388:policy/document-extractor-dev-kms-lambda-policy"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_iam_role_policy_attachment.attach_s3_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_s3_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-20250522153114543600000008"
    policy_arn = "arn:aws:iam::328307993388:policy/document-extractor-dev-s3-lambda-policy"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_iam_role_policy_attachment.attach_secrets_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_secrets_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-20250522153044573200000005"
    policy_arn = "arn:aws:iam::328307993388:policy/document-extractor-dev-secrets-lambda-policy"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_iam_role_policy_attachment.attach_sqs_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_sqs_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-2025052215314877690000000b"
    policy_arn = "arn:aws:iam::328307993388:policy/document-extractor-dev-sqs-lambda-policy"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_iam_role_policy_attachment.attach_textract_permission_to_role:
resource "aws_iam_role_policy_attachment" "attach_textract_permission_to_role" {
    id         = "document-extractor-dev-lambda-execution-role-20250522153044578100000006"
    policy_arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
    role       = "document-extractor-dev-lambda-execution-role"
}

# aws_kms_key.encryption:
resource "aws_kms_key" "encryption" {
    arn                                = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    bypass_policy_lockout_safety_check = false
    customer_master_key_spec           = "SYMMETRIC_DEFAULT"
    deletion_window_in_days            = 7
    description                        = "Data encryption for document-extractor"
    enable_key_rotation                = true
    id                                 = "2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    is_enabled                         = true
    key_id                             = "2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    key_usage                          = "ENCRYPT_DECRYPT"
    multi_region                       = false
    policy                             = jsonencode(
        {
            Id        = "key-default-1"
            Statement = [
                {
                    Action    = "kms:*"
                    Effect    = "Allow"
                    Principal = {
                        AWS = "arn:aws:iam::328307993388:root"
                    }
                    Resource  = "*"
                    Sid       = "Enable IAM User Permissions"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    rotation_period_in_days            = 365
    tags                               = {}
    tags_all                           = {
        "project" = "document-extractor-dev"
    }
}

# aws_lambda_event_source_mapping.invoke_dynamodb_writer_from_sqs:
resource "aws_lambda_event_source_mapping" "invoke_dynamodb_writer_from_sqs" {
    arn                                = "arn:aws:lambda:us-west-1:328307993388:event-source-mapping:b32111fd-5cd6-45fd-b193-ac415949bc48"
    batch_size                         = 10
    bisect_batch_on_function_error     = false
    enabled                            = true
    event_source_arn                   = "arn:aws:sqs:us-west-1:328307993388:document-extractor-dev-to-dynamodb"
    function_arn                       = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-write-to-dynamodb"
    function_name                      = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-write-to-dynamodb"
    function_response_types            = []
    id                                 = "b32111fd-5cd6-45fd-b193-ac415949bc48"
    last_modified                      = "2025-05-22T15:35:05Z"
    maximum_batching_window_in_seconds = 0
    maximum_record_age_in_seconds      = 0
    maximum_retry_attempts             = 0
    parallelization_factor             = 0
    queues                             = []
    state                              = "Enabled"
    state_transition_reason            = "USER_INITIATED"
    tags                               = {}
    tags_all                           = {
        "project" = "document-extractor-dev"
    }
    topics                             = []
    tumbling_window_in_seconds         = 0
    uuid                               = "b32111fd-5cd6-45fd-b193-ac415949bc48"
}

# aws_lambda_function.authorizer:
resource "aws_lambda_function" "authorizer" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-authorizer"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-authorizer"
    handler                        = "src.external.aws.lambdas.authenticate.lambda_handler"
    id                             = "document-extractor-dev-authorizer"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-authorizer/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:48:51.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-authorizer:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-authorizer:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = {
            "ENVIRONMENT" = "dev"
        }
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-authorizer"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# aws_lambda_function.text_extract:
resource "aws_lambda_function" "text_extract" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-text-extract"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-text-extract"
    handler                        = "src.external.aws.lambdas.text_extractor.lambda_handler"
    id                             = "document-extractor-dev-text-extract"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-text-extract/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:48:30.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-text-extract:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-text-extract:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = (sensitive value)
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-text-extract"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# aws_lambda_function.write_to_dynamodb:
resource "aws_lambda_function" "write_to_dynamodb" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-write-to-dynamodb"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-write-to-dynamodb"
    handler                        = "src.external.aws.lambdas.sqs_dynamo_writer.lambda_handler"
    id                             = "document-extractor-dev-write-to-dynamodb"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-write-to-dynamodb/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:48:11.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-write-to-dynamodb:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-write-to-dynamodb:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = {
            "DYNAMODB_TABLE" = "document-extractor-dev-text-extract"
            "SQS_QUEUE_URL"  = "https://sqs.us-west-1.amazonaws.com/328307993388/document-extractor-dev-to-dynamodb"
        }
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-write-to-dynamodb"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# aws_lambda_permission.allow_bucket_invoke:
resource "aws_lambda_permission" "allow_bucket_invoke" {
    action        = "lambda:InvokeFunction"
    function_name = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-text-extract"
    id            = "AllowExecutionFromS3Bucket"
    principal     = "s3.amazonaws.com"
    source_arn    = "arn:aws:s3:::document-extractor-dev-documents-328307993388"
    statement_id  = "AllowExecutionFromS3Bucket"
}

# aws_lambda_permission.api_gateway_invoke_authorizer:
resource "aws_lambda_permission" "api_gateway_invoke_authorizer" {
    action        = "lambda:InvokeFunction"
    function_name = "document-extractor-dev-authorizer"
    id            = "AllowExecutionFromApiGateway"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/*/*"
    statement_id  = "AllowExecutionFromApiGateway"
}

# aws_lambda_provisioned_concurrency_config.authorizer_concurrency:
resource "aws_lambda_provisioned_concurrency_config" "authorizer_concurrency" {
    function_name                     = "document-extractor-dev-authorizer"
    id                                = "document-extractor-dev-authorizer,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}

# aws_lambda_provisioned_concurrency_config.text_extract_concurrency:
resource "aws_lambda_provisioned_concurrency_config" "text_extract_concurrency" {
    function_name                     = "document-extractor-dev-text-extract"
    id                                = "document-extractor-dev-text-extract,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}

# aws_lambda_provisioned_concurrency_config.write_to_dynamodb_concurrency:
resource "aws_lambda_provisioned_concurrency_config" "write_to_dynamodb_concurrency" {
    function_name                     = "document-extractor-dev-write-to-dynamodb"
    id                                = "document-extractor-dev-write-to-dynamodb,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}

# aws_s3_bucket.document_storage:
resource "aws_s3_bucket" "document_storage" {
    arn                         = "arn:aws:s3:::document-extractor-dev-documents-328307993388"
    bucket                      = "document-extractor-dev-documents-328307993388"
    bucket_domain_name          = "document-extractor-dev-documents-328307993388.s3.amazonaws.com"
    bucket_regional_domain_name = "document-extractor-dev-documents-328307993388.s3.us-west-1.amazonaws.com"
    force_destroy               = false
    hosted_zone_id              = "Z2F56UZL2M1ACD"
    id                          = "document-extractor-dev-documents-328307993388"
    object_lock_enabled         = false
    region                      = "us-west-1"
    request_payer               = "BucketOwner"
    tags                        = {}
    tags_all                    = {
        "project" = "document-extractor-dev"
    }

    grant {
        id          = "8c3f17ff516da15e6f5aab48ecdb83925bea44ff492b5a28e507db8e94e3c531"
        permissions = [
            "FULL_CONTROL",
        ]
        type        = "CanonicalUser"
    }

    lifecycle_rule {
        abort_incomplete_multipart_upload_days = 0
        enabled                                = true
        id                                     = "delete-uploaded-documents"
        prefix                                 = "input/"
        tags                                   = {}

        expiration {
            days                         = 31
            expired_object_delete_marker = false
        }
    }

    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = false

            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    versioning {
        enabled    = false
        mfa_delete = false
    }
}

# aws_s3_bucket.website_storage:
resource "aws_s3_bucket" "website_storage" {
    arn                         = "arn:aws:s3:::document-extractor-dev-website-328307993388"
    bucket                      = "document-extractor-dev-website-328307993388"
    bucket_domain_name          = "document-extractor-dev-website-328307993388.s3.amazonaws.com"
    bucket_regional_domain_name = "document-extractor-dev-website-328307993388.s3.us-west-1.amazonaws.com"
    force_destroy               = true
    hosted_zone_id              = "Z2F56UZL2M1ACD"
    id                          = "document-extractor-dev-website-328307993388"
    object_lock_enabled         = false
    policy                      = jsonencode(
        {
            Statement = [
                {
                    Action    = "s3:GetObject"
                    Condition = {
                        StringEquals = {
                            "AWS:SourceArn" = "arn:aws:cloudfront::328307993388:distribution/ENWTZLUASCDJZ"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Service = "cloudfront.amazonaws.com"
                    }
                    Resource  = "arn:aws:s3:::document-extractor-dev-website-328307993388/*"
                    Sid       = "AllowCloudFront"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    region                      = "us-west-1"
    request_payer               = "BucketOwner"
    tags                        = {}
    tags_all                    = {
        "project" = "document-extractor-dev"
    }
    website_domain              = "s3-website-us-west-1.amazonaws.com"
    website_endpoint            = "document-extractor-dev-website-328307993388.s3-website-us-west-1.amazonaws.com"

    grant {
        id          = "8c3f17ff516da15e6f5aab48ecdb83925bea44ff492b5a28e507db8e94e3c531"
        permissions = [
            "FULL_CONTROL",
        ]
        type        = "CanonicalUser"
    }

    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = false

            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    versioning {
        enabled    = true
        mfa_delete = false
    }

    website {
        error_document = "index.html"
        index_document = "index.html"
    }
}

# aws_s3_bucket_lifecycle_configuration.document_storage_lifecycles:
resource "aws_s3_bucket_lifecycle_configuration" "document_storage_lifecycles" {
    bucket                                 = "document-extractor-dev-documents-328307993388"
    id                                     = "document-extractor-dev-documents-328307993388"
    transition_default_minimum_object_size = "all_storage_classes_128K"

    rule {
        id     = "delete-uploaded-documents"
        status = "Enabled"

        expiration {
            days                         = 31
            expired_object_delete_marker = false
        }

        filter {
            prefix = "input/"
        }
    }
}

# aws_s3_bucket_notification.notify_on_input_data:
resource "aws_s3_bucket_notification" "notify_on_input_data" {
    bucket      = "document-extractor-dev-documents-328307993388"
    eventbridge = false
    id          = "document-extractor-dev-documents-328307993388"

    lambda_function {
        events              = [
            "s3:ObjectCreated:*",
        ]
        filter_prefix       = "input/"
        id                  = "tf-s3-lambda-2025052215342622090000000d"
        lambda_function_arn = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-text-extract"
    }
}

# aws_s3_bucket_policy.website_read:
resource "aws_s3_bucket_policy" "website_read" {
    bucket = "document-extractor-dev-website-328307993388"
    id     = "document-extractor-dev-website-328307993388"
    policy = jsonencode(
        {
            Statement = [
                {
                    Action    = "s3:GetObject"
                    Condition = {
                        StringEquals = {
                            "AWS:SourceArn" = "arn:aws:cloudfront::328307993388:distribution/ENWTZLUASCDJZ"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Service = "cloudfront.amazonaws.com"
                    }
                    Resource  = "arn:aws:s3:::document-extractor-dev-website-328307993388/*"
                    Sid       = "AllowCloudFront"
                },
            ]
            Version   = "2012-10-17"
        }
    )
}

# aws_s3_bucket_public_access_block.private_website:
resource "aws_s3_bucket_public_access_block" "private_website" {
    block_public_acls       = true
    block_public_policy     = true
    bucket                  = "document-extractor-dev-website-328307993388"
    id                      = "document-extractor-dev-website-328307993388"
    ignore_public_acls      = true
    restrict_public_buckets = false
}

# aws_s3_bucket_versioning.website_storage_versioning:
resource "aws_s3_bucket_versioning" "website_storage_versioning" {
    bucket = "document-extractor-dev-website-328307993388"
    id     = "document-extractor-dev-website-328307993388"

    versioning_configuration {
        status = "Enabled"
    }
}

# aws_s3_bucket_website_configuration.website_configuration:
resource "aws_s3_bucket_website_configuration" "website_configuration" {
    bucket           = "document-extractor-dev-website-328307993388"
    id               = "document-extractor-dev-website-328307993388"
    website_domain   = "s3-website-us-west-1.amazonaws.com"
    website_endpoint = "document-extractor-dev-website-328307993388.s3-website-us-west-1.amazonaws.com"

    error_document {
        key = "index.html"
    }

    index_document {
        suffix = "index.html"
    }
}

# aws_s3_object.website_files["GSA-logo.7a2abfc3.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/GSA-logo.7a2abfc3.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "a5f5373f259f83f81912e6a91cf2c388"
    force_destroy          = false
    id                     = "GSA-logo.7a2abfc3.svg"
    key                    = "GSA-logo.7a2abfc3.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//GSA-logo.7a2abfc3.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["GSA-logo.ece32ed3.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/GSA-logo.ece32ed3.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "10d4fa294b895ffbd2709b3db2056484"
    force_destroy          = false
    id                     = "GSA-logo.ece32ed3.svg"
    key                    = "GSA-logo.ece32ed3.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//GSA-logo.ece32ed3.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Bold.967b2108.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Bold.967b2108.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "115f5a1d96eaa67ffee687960dd770f3"
    force_destroy          = false
    id                     = "Latin-Merriweather-Bold.967b2108.woff2"
    key                    = "Latin-Merriweather-Bold.967b2108.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Bold.967b2108.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Bold.cdbf7e95.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Bold.cdbf7e95.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "115f5a1d96eaa67ffee687960dd770f3"
    force_destroy          = false
    id                     = "Latin-Merriweather-Bold.cdbf7e95.woff2"
    key                    = "Latin-Merriweather-Bold.cdbf7e95.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Bold.cdbf7e95.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-BoldItalic.32dc0025.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-BoldItalic.32dc0025.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "2750a1e9d21f8b94f614bf36a3c53a0a"
    force_destroy          = false
    id                     = "Latin-Merriweather-BoldItalic.32dc0025.woff2"
    key                    = "Latin-Merriweather-BoldItalic.32dc0025.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-BoldItalic.32dc0025.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-BoldItalic.e58256dc.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-BoldItalic.e58256dc.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "2750a1e9d21f8b94f614bf36a3c53a0a"
    force_destroy          = false
    id                     = "Latin-Merriweather-BoldItalic.e58256dc.woff2"
    key                    = "Latin-Merriweather-BoldItalic.e58256dc.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-BoldItalic.e58256dc.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Italic.959c3872.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Italic.959c3872.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "2412c72a898d4ed8f67e1351f7360067"
    force_destroy          = false
    id                     = "Latin-Merriweather-Italic.959c3872.woff2"
    key                    = "Latin-Merriweather-Italic.959c3872.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Italic.959c3872.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Italic.e2716ed3.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Italic.e2716ed3.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "2412c72a898d4ed8f67e1351f7360067"
    force_destroy          = false
    id                     = "Latin-Merriweather-Italic.e2716ed3.woff2"
    key                    = "Latin-Merriweather-Italic.e2716ed3.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Italic.e2716ed3.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Light.1ad1a1d8.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Light.1ad1a1d8.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "4f0fb5042c21b257ae0707783ac29626"
    force_destroy          = false
    id                     = "Latin-Merriweather-Light.1ad1a1d8.woff2"
    key                    = "Latin-Merriweather-Light.1ad1a1d8.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Light.1ad1a1d8.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Light.fbc4393c.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Light.fbc4393c.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "4f0fb5042c21b257ae0707783ac29626"
    force_destroy          = false
    id                     = "Latin-Merriweather-Light.fbc4393c.woff2"
    key                    = "Latin-Merriweather-Light.fbc4393c.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Light.fbc4393c.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-LightItalic.1c9df738.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-LightItalic.1c9df738.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "08acae9c0b84b1ac1ea5cc76846bb3f4"
    force_destroy          = false
    id                     = "Latin-Merriweather-LightItalic.1c9df738.woff2"
    key                    = "Latin-Merriweather-LightItalic.1c9df738.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-LightItalic.1c9df738.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-LightItalic.f4af3b7f.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-LightItalic.f4af3b7f.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "08acae9c0b84b1ac1ea5cc76846bb3f4"
    force_destroy          = false
    id                     = "Latin-Merriweather-LightItalic.f4af3b7f.woff2"
    key                    = "Latin-Merriweather-LightItalic.f4af3b7f.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-LightItalic.f4af3b7f.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Regular.04046ce8.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Regular.04046ce8.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "fa9b615a25bdf9c42a7f6ffa223c1eb0"
    force_destroy          = false
    id                     = "Latin-Merriweather-Regular.04046ce8.woff2"
    key                    = "Latin-Merriweather-Regular.04046ce8.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Regular.04046ce8.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["Latin-Merriweather-Regular.66d4c170.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/Latin-Merriweather-Regular.66d4c170.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "fa9b615a25bdf9c42a7f6ffa223c1eb0"
    force_destroy          = false
    id                     = "Latin-Merriweather-Regular.66d4c170.woff2"
    key                    = "Latin-Merriweather-Regular.66d4c170.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//Latin-Merriweather-Regular.66d4c170.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["add.29db0c6a.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/add.29db0c6a.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "0f088d7d3e8ada1b661f2736cb506e14"
    force_destroy          = false
    id                     = "add.29db0c6a.svg"
    key                    = "add.29db0c6a.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//add.29db0c6a.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["add.d491396d.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/add.d491396d.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "7efc1415746d7f0067eefcdc3321ba52"
    force_destroy          = false
    id                     = "add.d491396d.svg"
    key                    = "add.d491396d.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//add.d491396d.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["arrow_back.c9ac1a0e.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/arrow_back.c9ac1a0e.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "e57e9cb53111150e4f51e1121220a95a"
    force_destroy          = false
    id                     = "arrow_back.c9ac1a0e.svg"
    key                    = "arrow_back.c9ac1a0e.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//arrow_back.c9ac1a0e.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["arrow_back.e4913c69.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/arrow_back.e4913c69.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "2cd7c1dd5b9ac84ed414e4cc7f0ac828"
    force_destroy          = false
    id                     = "arrow_back.e4913c69.svg"
    key                    = "arrow_back.e4913c69.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//arrow_back.e4913c69.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["calendar_today.3a803a7a.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/calendar_today.3a803a7a.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "8b326af3e58921f55b0f7b91c15a3332"
    force_destroy          = false
    id                     = "calendar_today.3a803a7a.svg"
    key                    = "calendar_today.3a803a7a.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//calendar_today.3a803a7a.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["calendar_today.ce6eaa81.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/calendar_today.ce6eaa81.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "a873a20cec4307294405eb1ba4eb2e72"
    force_destroy          = false
    id                     = "calendar_today.ce6eaa81.svg"
    key                    = "calendar_today.ce6eaa81.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//calendar_today.ce6eaa81.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["check--blue-60v.7604a0f6.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/check--blue-60v.7604a0f6.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "313b2d5d8e007f70376ec216c87db68a"
    force_destroy          = false
    id                     = "check--blue-60v.7604a0f6.svg"
    key                    = "check--blue-60v.7604a0f6.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//check--blue-60v.7604a0f6.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["check--blue-60v.982d9f95.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/check--blue-60v.982d9f95.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "64bd8ec50798f10e75b0b52772a83acf"
    force_destroy          = false
    id                     = "check--blue-60v.982d9f95.svg"
    key                    = "check--blue-60v.982d9f95.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//check--blue-60v.982d9f95.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["check_circle.120511e4.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/check_circle.120511e4.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "8a6c0918758299283e904826d8bf66f5"
    force_destroy          = false
    id                     = "check_circle.120511e4.svg"
    key                    = "check_circle.120511e4.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//check_circle.120511e4.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["check_circle.a3900be5.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/check_circle.a3900be5.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "03c3ff80715e40101493a17f864bfa6e"
    force_destroy          = false
    id                     = "check_circle.a3900be5.svg"
    key                    = "check_circle.a3900be5.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//check_circle.a3900be5.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["checkbox-indeterminate-alt.5e7abfcf.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/checkbox-indeterminate-alt.5e7abfcf.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "d00c26327b052bb4cfe366292f996369"
    force_destroy          = false
    id                     = "checkbox-indeterminate-alt.5e7abfcf.svg"
    key                    = "checkbox-indeterminate-alt.5e7abfcf.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//checkbox-indeterminate-alt.5e7abfcf.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["checkbox-indeterminate-alt.a6b9b5ac.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/checkbox-indeterminate-alt.a6b9b5ac.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "93b4958c6c02d948cd8f495eb245b74b"
    force_destroy          = false
    id                     = "checkbox-indeterminate-alt.a6b9b5ac.svg"
    key                    = "checkbox-indeterminate-alt.a6b9b5ac.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//checkbox-indeterminate-alt.a6b9b5ac.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["checkbox-indeterminate.08aa88cd.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/checkbox-indeterminate.08aa88cd.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "8a80f6567e7aa6243704d7178569e3ca"
    force_destroy          = false
    id                     = "checkbox-indeterminate.08aa88cd.svg"
    key                    = "checkbox-indeterminate.08aa88cd.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//checkbox-indeterminate.08aa88cd.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["checkbox-indeterminate.db2c5d96.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/checkbox-indeterminate.db2c5d96.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "c60f49da349a00d84dc9fc7a4f5cc62b"
    force_destroy          = false
    id                     = "checkbox-indeterminate.db2c5d96.svg"
    key                    = "checkbox-indeterminate.db2c5d96.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//checkbox-indeterminate.db2c5d96.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["close.3962dfa0.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/close.3962dfa0.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "c0865955ca37002dd8e2883f888c07c7"
    force_destroy          = false
    id                     = "close.3962dfa0.svg"
    key                    = "close.3962dfa0.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//close.3962dfa0.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["close.bf51193b.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/close.bf51193b.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "036587ca3d855f3ac5fbd8f43b4122e7"
    force_destroy          = false
    id                     = "close.bf51193b.svg"
    key                    = "close.bf51193b.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//close.bf51193b.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["correct8-alt.8f8dac23.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/correct8-alt.8f8dac23.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "f5905b100ed5db0b8a1d60de8afeb676"
    force_destroy          = false
    id                     = "correct8-alt.8f8dac23.svg"
    key                    = "correct8-alt.8f8dac23.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//correct8-alt.8f8dac23.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["correct8-alt.c14d1430.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/correct8-alt.c14d1430.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "2b82d538111387f92a11249246553a91"
    force_destroy          = false
    id                     = "correct8-alt.c14d1430.svg"
    key                    = "correct8-alt.c14d1430.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//correct8-alt.c14d1430.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["correct8.10e8a7ef.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/correct8.10e8a7ef.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "4ba9644a1430fccf876129a9491c5eba"
    force_destroy          = false
    id                     = "correct8.10e8a7ef.svg"
    key                    = "correct8.10e8a7ef.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//correct8.10e8a7ef.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["correct8.2dc455b8.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/correct8.2dc455b8.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "d63df17ba88fd8bf61d256e3e874ba47"
    force_destroy          = false
    id                     = "correct8.2dc455b8.svg"
    key                    = "correct8.2dc455b8.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//correct8.2dc455b8.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["error--white.73d13870.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/error--white.73d13870.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "06a11ba59b006a7d492d169637bf1548"
    force_destroy          = false
    id                     = "error--white.73d13870.svg"
    key                    = "error--white.73d13870.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//error--white.73d13870.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["error--white.dcc8cafd.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/error--white.dcc8cafd.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "bfbcdca379210ce5cfc9db84be8f5dc1"
    force_destroy          = false
    id                     = "error--white.dcc8cafd.svg"
    key                    = "error--white.dcc8cafd.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//error--white.dcc8cafd.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["error.1986e136.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/error.1986e136.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "fde17cc10d5eef259b5bbe18e46fab0c"
    force_destroy          = false
    id                     = "error.1986e136.svg"
    key                    = "error.1986e136.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//error.1986e136.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["error.35f61f4b.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/error.35f61f4b.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "d13a59b1e5cd75dd20b7a028671532dc"
    force_destroy          = false
    id                     = "error.35f61f4b.svg"
    key                    = "error.35f61f4b.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//error.35f61f4b.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["expand_less.5bb6de10.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/expand_less.5bb6de10.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "dfebee63a045b8ccc14dbe5f31760a27"
    force_destroy          = false
    id                     = "expand_less.5bb6de10.svg"
    key                    = "expand_less.5bb6de10.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//expand_less.5bb6de10.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["expand_less.e2846957.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/expand_less.e2846957.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "625e5aef439c7c58811ff4311fbd9ad2"
    force_destroy          = false
    id                     = "expand_less.e2846957.svg"
    key                    = "expand_less.e2846957.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//expand_less.e2846957.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["expand_more.0d06b804.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/expand_more.0d06b804.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "42030f327d3bac1e3c1b28d6b6cdd39d"
    force_destroy          = false
    id                     = "expand_more.0d06b804.svg"
    key                    = "expand_more.0d06b804.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//expand_more.0d06b804.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["expand_more.3ac36c78.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/expand_more.3ac36c78.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "ef8f6951a107bd87f958f7da30cc055c"
    force_destroy          = false
    id                     = "expand_more.3ac36c78.svg"
    key                    = "expand_more.3ac36c78.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//expand_more.3ac36c78.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-excel.323d5d7b.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-excel.323d5d7b.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "24e33cd8762e554e0e34c96374ea2590"
    force_destroy          = false
    id                     = "file-excel.323d5d7b.svg"
    key                    = "file-excel.323d5d7b.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-excel.323d5d7b.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-excel.c90d2036.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-excel.c90d2036.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "22c2afbcb82b6edd4a417ca47b6b5e19"
    force_destroy          = false
    id                     = "file-excel.c90d2036.svg"
    key                    = "file-excel.c90d2036.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-excel.c90d2036.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-pdf.248e68e5.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-pdf.248e68e5.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "966a8ca1993ba85a960c368b55ef4e66"
    force_destroy          = false
    id                     = "file-pdf.248e68e5.svg"
    key                    = "file-pdf.248e68e5.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-pdf.248e68e5.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-pdf.51e66388.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-pdf.51e66388.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "51e6e0e5d44a7b72c1177086adf034a8"
    force_destroy          = false
    id                     = "file-pdf.51e66388.svg"
    key                    = "file-pdf.51e66388.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-pdf.51e66388.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-video.a3a38638.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-video.a3a38638.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "7d37155a50361daba2e04e5350ee1d12"
    force_destroy          = false
    id                     = "file-video.a3a38638.svg"
    key                    = "file-video.a3a38638.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-video.a3a38638.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-video.d309c165.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-video.d309c165.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "cead665f630764bb98d255029d937b47"
    force_destroy          = false
    id                     = "file-video.d309c165.svg"
    key                    = "file-video.d309c165.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-video.d309c165.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-word.75e83f68.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-word.75e83f68.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "e351d03815ea43bdfef10273d193c898"
    force_destroy          = false
    id                     = "file-word.75e83f68.svg"
    key                    = "file-word.75e83f68.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-word.75e83f68.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file-word.896caaf0.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file-word.896caaf0.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "097753fc352f35b41d6bbaf468cceeb6"
    force_destroy          = false
    id                     = "file-word.896caaf0.svg"
    key                    = "file-word.896caaf0.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file-word.896caaf0.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file.057d5652.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file.057d5652.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "9fd817a14d685ce75a9c494c482de9f4"
    force_destroy          = false
    id                     = "file.057d5652.svg"
    key                    = "file.057d5652.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file.057d5652.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["file.f51e21d7.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/file.f51e21d7.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "f203bc7af348e50a50f017a2f11458d4"
    force_destroy          = false
    id                     = "file.f51e21d7.svg"
    key                    = "file.f51e21d7.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//file.f51e21d7.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["hero.3538e009.jpg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/hero.3538e009.jpg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/jpeg"
    etag                   = "3e76d9e4fadd5f14d44a7093c5633c93"
    force_destroy          = false
    id                     = "hero.3538e009.jpg"
    key                    = "hero.3538e009.jpg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//hero.3538e009.jpg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["hero.abe074f7.jpg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/hero.abe074f7.jpg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/jpeg"
    etag                   = "07c4bca195b13a0e98bcb89dfce5372b"
    force_destroy          = false
    id                     = "hero.abe074f7.jpg"
    key                    = "hero.abe074f7.jpg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//hero.abe074f7.jpg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["icon-dot-gov.1cc2b2c5.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/icon-dot-gov.1cc2b2c5.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "1c9e4fc238c699bb23f13c7dc361ee57"
    force_destroy          = false
    id                     = "icon-dot-gov.1cc2b2c5.svg"
    key                    = "icon-dot-gov.1cc2b2c5.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//icon-dot-gov.1cc2b2c5.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["icon-dot-gov.86228b6b.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/icon-dot-gov.86228b6b.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "d239f0908996c922f3650b510d0d535f"
    force_destroy          = false
    id                     = "icon-dot-gov.86228b6b.svg"
    key                    = "icon-dot-gov.86228b6b.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//icon-dot-gov.86228b6b.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["icon-https.3b0ffef2.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/icon-https.3b0ffef2.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "68d04de8513589d73c2bb79e68297eb1"
    force_destroy          = false
    id                     = "icon-https.3b0ffef2.svg"
    key                    = "icon-https.3b0ffef2.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//icon-https.3b0ffef2.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["icon-https.b6eca6f6.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/icon-https.b6eca6f6.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "72f0c58199a2f225400d70968a9afc66"
    force_destroy          = false
    id                     = "icon-https.b6eca6f6.svg"
    key                    = "icon-https.b6eca6f6.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//icon-https.b6eca6f6.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["index.html"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/index.html"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "text/html; charset=utf-8"
    etag                   = "2ccd3b4b1a5e848c82180b88d1d08e90"
    force_destroy          = false
    id                     = "index.html"
    key                    = "index.html"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//index.html"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "HZGqmpGf35Bv23Ra_pKk_uDMAHR39KsX"
}

# aws_s3_object.website_files["info.40b16694.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/info.40b16694.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "73ce9f949b72cc08795cbc8db357fb24"
    force_destroy          = false
    id                     = "info.40b16694.svg"
    key                    = "info.40b16694.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//info.40b16694.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["info.85fe97af.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/info.85fe97af.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "dad4bc60b84bb6fccf76651f10ef4b34"
    force_destroy          = false
    id                     = "info.85fe97af.svg"
    key                    = "info.85fe97af.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//info.85fe97af.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["launch--white.626c08f5.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/launch--white.626c08f5.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "caeb0df516eda2356247204bb01d2917"
    force_destroy          = false
    id                     = "launch--white.626c08f5.svg"
    key                    = "launch--white.626c08f5.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//launch--white.626c08f5.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["launch--white.6c179f60.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/launch--white.6c179f60.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "57ea618e288611d72609ebc341de3fdc"
    force_destroy          = false
    id                     = "launch--white.6c179f60.svg"
    key                    = "launch--white.6c179f60.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//launch--white.6c179f60.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["launch.2cde378c.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/launch.2cde378c.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "c8059dd52639b419d3303934a8ea9fd0"
    force_destroy          = false
    id                     = "launch.2cde378c.svg"
    key                    = "launch.2cde378c.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//launch.2cde378c.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["launch.f4de218c.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/launch.f4de218c.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "13a426a0665b8b448e3654a0cff206e7"
    force_destroy          = false
    id                     = "launch.f4de218c.svg"
    key                    = "launch.f4de218c.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//launch.f4de218c.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["loader.7402c183.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/loader.7402c183.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "584fad42f8bb8b5f739a50abfd94a314"
    force_destroy          = false
    id                     = "loader.7402c183.svg"
    key                    = "loader.7402c183.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//loader.7402c183.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["loader.e58cf242.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/loader.e58cf242.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "c1ce57d695c823c3ca5133b1c56606f7"
    force_destroy          = false
    id                     = "loader.e58cf242.svg"
    key                    = "loader.e58cf242.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//loader.e58cf242.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_before.7d672c1a.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_before.7d672c1a.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "d7aaa21052caa26866fbd0d372f73a99"
    force_destroy          = false
    id                     = "navigate_before.7d672c1a.svg"
    key                    = "navigate_before.7d672c1a.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_before.7d672c1a.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_before.be211c2e.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_before.be211c2e.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "248acd5ee98e1806e7d42ab947b2ba68"
    force_destroy          = false
    id                     = "navigate_before.be211c2e.svg"
    key                    = "navigate_before.be211c2e.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_before.be211c2e.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_far_before.65b60266.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_far_before.65b60266.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "2a1f57e70b9419e51c03877b8c0028f8"
    force_destroy          = false
    id                     = "navigate_far_before.65b60266.svg"
    key                    = "navigate_far_before.65b60266.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_far_before.65b60266.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_far_before.904e4c63.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_far_before.904e4c63.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "7321f53317b2771b0c81721e637bff60"
    force_destroy          = false
    id                     = "navigate_far_before.904e4c63.svg"
    key                    = "navigate_far_before.904e4c63.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_far_before.904e4c63.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_far_next.37ce8b6e.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_far_next.37ce8b6e.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "a4306f47c1f8155e74bc7edb5ea95487"
    force_destroy          = false
    id                     = "navigate_far_next.37ce8b6e.svg"
    key                    = "navigate_far_next.37ce8b6e.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_far_next.37ce8b6e.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_far_next.bd2c92a4.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_far_next.bd2c92a4.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "7aa4ae9f1d1397a64bb5f34aab3f3a95"
    force_destroy          = false
    id                     = "navigate_far_next.bd2c92a4.svg"
    key                    = "navigate_far_next.bd2c92a4.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_far_next.bd2c92a4.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_next.bc7c1a4e.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_next.bc7c1a4e.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "a8e5c097da5bdbe97880bfbd67b99d38"
    force_destroy          = false
    id                     = "navigate_next.bc7c1a4e.svg"
    key                    = "navigate_next.bc7c1a4e.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_next.bc7c1a4e.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["navigate_next.fb4be146.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/navigate_next.fb4be146.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "e4449ac35306cc39af51a48bf48a2f90"
    force_destroy          = false
    id                     = "navigate_next.fb4be146.svg"
    key                    = "navigate_next.fb4be146.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//navigate_next.fb4be146.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["pdf.worker.min.mjs"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/pdf.worker.min.mjs"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "213ab48603654c9423b7d45e2ee4a48a"
    force_destroy          = false
    id                     = "pdf.worker.min.mjs"
    key                    = "pdf.worker.min.mjs"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//pdf.worker.min.mjs"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "6JZajVCr5eHRzeES2PkEnwAjUV_Zd.3b"
}

# aws_s3_object.website_files["remove.27bfc20f.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/remove.27bfc20f.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "9fcf8726387df8b26f01dec005aa740a"
    force_destroy          = false
    id                     = "remove.27bfc20f.svg"
    key                    = "remove.27bfc20f.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//remove.27bfc20f.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["remove.ca324d27.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/remove.ca324d27.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "28fac28bf8d7a32df31759deac776400"
    force_destroy          = false
    id                     = "remove.ca324d27.svg"
    key                    = "remove.ca324d27.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//remove.ca324d27.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-300.40a89411.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-300.40a89411.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "db95b37ec6ef04cd349d098941e5f70b"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-300.40a89411.woff2"
    key                    = "roboto-mono-v5-latin-300.40a89411.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-300.40a89411.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-300.98978b08.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-300.98978b08.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "db95b37ec6ef04cd349d098941e5f70b"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-300.98978b08.woff2"
    key                    = "roboto-mono-v5-latin-300.98978b08.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-300.98978b08.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-300italic.1710c37a.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-300italic.1710c37a.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "18357ddaddc4d4f13c5f49985327a2db"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-300italic.1710c37a.woff2"
    key                    = "roboto-mono-v5-latin-300italic.1710c37a.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-300italic.1710c37a.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-300italic.af4ea91a.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-300italic.af4ea91a.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "18357ddaddc4d4f13c5f49985327a2db"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-300italic.af4ea91a.woff2"
    key                    = "roboto-mono-v5-latin-300italic.af4ea91a.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-300italic.af4ea91a.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-700.d309a69d.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-700.d309a69d.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "4bc0bd04b8b2f6730b5997503fa4ce5a"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-700.d309a69d.woff2"
    key                    = "roboto-mono-v5-latin-700.d309a69d.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-700.d309a69d.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-700.df366d23.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-700.df366d23.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "4bc0bd04b8b2f6730b5997503fa4ce5a"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-700.df366d23.woff2"
    key                    = "roboto-mono-v5-latin-700.df366d23.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-700.df366d23.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-700italic.03671595.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-700italic.03671595.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "5eca10b5e58c4e2a8164f89bef5dbd7e"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-700italic.03671595.woff2"
    key                    = "roboto-mono-v5-latin-700italic.03671595.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-700italic.03671595.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-700italic.2b983f5d.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-700italic.2b983f5d.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "5eca10b5e58c4e2a8164f89bef5dbd7e"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-700italic.2b983f5d.woff2"
    key                    = "roboto-mono-v5-latin-700italic.2b983f5d.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-700italic.2b983f5d.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-italic.7226ad2c.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-italic.7226ad2c.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "55befc28b6c06f712a38e2f4153967e1"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-italic.7226ad2c.woff2"
    key                    = "roboto-mono-v5-latin-italic.7226ad2c.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-italic.7226ad2c.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-italic.9209c633.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-italic.9209c633.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "55befc28b6c06f712a38e2f4153967e1"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-italic.9209c633.woff2"
    key                    = "roboto-mono-v5-latin-italic.9209c633.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-italic.9209c633.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-regular.e048516f.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-regular.e048516f.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "e92cc0fb9e1a7debc138224fd02a462a"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-regular.e048516f.woff2"
    key                    = "roboto-mono-v5-latin-regular.e048516f.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-regular.e048516f.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["roboto-mono-v5-latin-regular.ec7832e5.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/roboto-mono-v5-latin-regular.ec7832e5.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "e92cc0fb9e1a7debc138224fd02a462a"
    force_destroy          = false
    id                     = "roboto-mono-v5-latin-regular.ec7832e5.woff2"
    key                    = "roboto-mono-v5-latin-regular.ec7832e5.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//roboto-mono-v5-latin-regular.ec7832e5.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["search.a724f1bc.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/search.a724f1bc.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "2be400ec2879d462e871c0f8f255e3d6"
    force_destroy          = false
    id                     = "search.a724f1bc.svg"
    key                    = "search.a724f1bc.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//search.a724f1bc.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["search.e5ee4fc2.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/search.e5ee4fc2.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "6aa89b3d4533e41fc29c59209167d0a2"
    force_destroy          = false
    id                     = "search.e5ee4fc2.svg"
    key                    = "search.e5ee4fc2.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//search.e5ee4fc2.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-bold-webfont.21f8979c.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-bold-webfont.21f8979c.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "f12f6a2f439c99a103193981f69c3353"
    force_destroy          = false
    id                     = "sourcesanspro-bold-webfont.21f8979c.woff2"
    key                    = "sourcesanspro-bold-webfont.21f8979c.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-bold-webfont.21f8979c.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-bold-webfont.5436602a.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-bold-webfont.5436602a.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "f12f6a2f439c99a103193981f69c3353"
    force_destroy          = false
    id                     = "sourcesanspro-bold-webfont.5436602a.woff2"
    key                    = "sourcesanspro-bold-webfont.5436602a.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-bold-webfont.5436602a.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-bolditalic-webfont.84e64ba8.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-bolditalic-webfont.84e64ba8.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "dae8945d820658d0cb8f15764e441cc6"
    force_destroy          = false
    id                     = "sourcesanspro-bolditalic-webfont.84e64ba8.woff2"
    key                    = "sourcesanspro-bolditalic-webfont.84e64ba8.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-bolditalic-webfont.84e64ba8.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-bolditalic-webfont.b61b42d2.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-bolditalic-webfont.b61b42d2.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "dae8945d820658d0cb8f15764e441cc6"
    force_destroy          = false
    id                     = "sourcesanspro-bolditalic-webfont.b61b42d2.woff2"
    key                    = "sourcesanspro-bolditalic-webfont.b61b42d2.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-bolditalic-webfont.b61b42d2.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-italic-webfont.82ff76d1.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-italic-webfont.82ff76d1.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "8740838d2f0e9325e59b6e3c007a7130"
    force_destroy          = false
    id                     = "sourcesanspro-italic-webfont.82ff76d1.woff2"
    key                    = "sourcesanspro-italic-webfont.82ff76d1.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-italic-webfont.82ff76d1.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-italic-webfont.ab90d6d1.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-italic-webfont.ab90d6d1.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "8740838d2f0e9325e59b6e3c007a7130"
    force_destroy          = false
    id                     = "sourcesanspro-italic-webfont.ab90d6d1.woff2"
    key                    = "sourcesanspro-italic-webfont.ab90d6d1.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-italic-webfont.ab90d6d1.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-light-webfont.e490d910.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-light-webfont.e490d910.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "4572c51ee35f958fd2d4f04211c2ddc8"
    force_destroy          = false
    id                     = "sourcesanspro-light-webfont.e490d910.woff2"
    key                    = "sourcesanspro-light-webfont.e490d910.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-light-webfont.e490d910.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-light-webfont.e70d4904.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-light-webfont.e70d4904.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "4572c51ee35f958fd2d4f04211c2ddc8"
    force_destroy          = false
    id                     = "sourcesanspro-light-webfont.e70d4904.woff2"
    key                    = "sourcesanspro-light-webfont.e70d4904.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-light-webfont.e70d4904.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-lightitalic-webfont.05b42991.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-lightitalic-webfont.05b42991.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "ffb6369e594a83b16001ca58c1ee9039"
    force_destroy          = false
    id                     = "sourcesanspro-lightitalic-webfont.05b42991.woff2"
    key                    = "sourcesanspro-lightitalic-webfont.05b42991.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-lightitalic-webfont.05b42991.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-lightitalic-webfont.c14df9bc.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-lightitalic-webfont.c14df9bc.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "ffb6369e594a83b16001ca58c1ee9039"
    force_destroy          = false
    id                     = "sourcesanspro-lightitalic-webfont.c14df9bc.woff2"
    key                    = "sourcesanspro-lightitalic-webfont.c14df9bc.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-lightitalic-webfont.c14df9bc.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-regular-webfont.76c0bde6.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-regular-webfont.76c0bde6.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "d67b548b833d70dda3779916f5415e7e"
    force_destroy          = false
    id                     = "sourcesanspro-regular-webfont.76c0bde6.woff2"
    key                    = "sourcesanspro-regular-webfont.76c0bde6.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-regular-webfont.76c0bde6.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["sourcesanspro-regular-webfont.a9d6b459.woff2"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/sourcesanspro-regular-webfont.a9d6b459.woff2"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "font/woff2"
    etag                   = "d67b548b833d70dda3779916f5415e7e"
    force_destroy          = false
    id                     = "sourcesanspro-regular-webfont.a9d6b459.woff2"
    key                    = "sourcesanspro-regular-webfont.a9d6b459.woff2"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//sourcesanspro-regular-webfont.a9d6b459.woff2"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.24de9d80.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.24de9d80.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "988b70b40be2f0314481900a5c536520"
    force_destroy          = false
    id                     = "ui.24de9d80.js"
    key                    = "ui.24de9d80.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.24de9d80.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.24de9d80.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.24de9d80.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "d10b75eab24e3b17c82dfe793bb0c197-2"
    force_destroy          = false
    id                     = "ui.24de9d80.js.map"
    key                    = "ui.24de9d80.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.24de9d80.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = ".S.34IQj0kAQhvdnmPlQEg1E61S8zYrN"
}

# aws_s3_object.website_files["ui.31b563d9.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.31b563d9.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "01f05bef6cafd19e0e1cb3bd102f0c1c"
    force_destroy          = false
    id                     = "ui.31b563d9.js"
    key                    = "ui.31b563d9.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.31b563d9.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.31b563d9.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.31b563d9.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "b4ab5047433ae9a15260c6280fab352f"
    force_destroy          = false
    id                     = "ui.31b563d9.js.map"
    key                    = "ui.31b563d9.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.31b563d9.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.383343a4.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.383343a4.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "d3c3ac003d73acd50a8fced8fd15b181"
    force_destroy          = false
    id                     = "ui.383343a4.js"
    key                    = "ui.383343a4.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.383343a4.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.383343a4.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.383343a4.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "2061e6c7acb903ff425164499447f426-2"
    force_destroy          = false
    id                     = "ui.383343a4.js.map"
    key                    = "ui.383343a4.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.383343a4.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "ckEM6PjYr8zpOhywI.QjYXHQe27ztMmK"
}

# aws_s3_object.website_files["ui.394b89ad.css"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.394b89ad.css"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "text/css; charset=utf-8"
    etag                   = "07639841c3f2c11c538edbd93de57a6f"
    force_destroy          = false
    id                     = "ui.394b89ad.css"
    key                    = "ui.394b89ad.css"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.394b89ad.css"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.394b89ad.css.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.394b89ad.css.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "aaae7f6b549c1b425538ad3a5e8f1244"
    force_destroy          = false
    id                     = "ui.394b89ad.css.map"
    key                    = "ui.394b89ad.css.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.394b89ad.css.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.4540ed92.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.4540ed92.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "b2a077c3c016057ede33fd7334f2ce63"
    force_destroy          = false
    id                     = "ui.4540ed92.js"
    key                    = "ui.4540ed92.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.4540ed92.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.4540ed92.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.4540ed92.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "700182aa0a2dcfdd93fc8291ecb10d29"
    force_destroy          = false
    id                     = "ui.4540ed92.js.map"
    key                    = "ui.4540ed92.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.4540ed92.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.4e22b301.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.4e22b301.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "245a950194a7e0f0e041ab26cbc1d290"
    force_destroy          = false
    id                     = "ui.4e22b301.js"
    key                    = "ui.4e22b301.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.4e22b301.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.4e22b301.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.4e22b301.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "81b90eb36e2b718a3dad1f0a9d6c6a49"
    force_destroy          = false
    id                     = "ui.4e22b301.js.map"
    key                    = "ui.4e22b301.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.4e22b301.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.7c42bb32.css"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.7c42bb32.css"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "text/css; charset=utf-8"
    etag                   = "c5a87ffc2db465beb40c24ba24485220"
    force_destroy          = false
    id                     = "ui.7c42bb32.css"
    key                    = "ui.7c42bb32.css"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.7c42bb32.css"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.7c42bb32.css.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.7c42bb32.css.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "d7e48f6e687b5c4e697c0e43999eec70"
    force_destroy          = false
    id                     = "ui.7c42bb32.css.map"
    key                    = "ui.7c42bb32.css.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.7c42bb32.css.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.9f367d21.css"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.9f367d21.css"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "text/css; charset=utf-8"
    etag                   = "e7bd07d0eec9674884a3010871dbb5a2"
    force_destroy          = false
    id                     = "ui.9f367d21.css"
    key                    = "ui.9f367d21.css"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.9f367d21.css"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.9f367d21.css.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.9f367d21.css.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "348e434f681101e28ae799774cbc7220"
    force_destroy          = false
    id                     = "ui.9f367d21.css.map"
    key                    = "ui.9f367d21.css.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.9f367d21.css.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.b82c2ba3.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.b82c2ba3.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "6cfa17821e273870c789a3b4daa991d0"
    force_destroy          = false
    id                     = "ui.b82c2ba3.js"
    key                    = "ui.b82c2ba3.js"
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.b82c2ba3.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "XcX7iLmWxLkmtoc0JirYJGB9Xf.giweL"
}

# aws_s3_object.website_files["ui.b82c2ba3.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.b82c2ba3.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "bb5a0d39b9f9186f155cde01e3abccb9-2"
    force_destroy          = false
    id                     = "ui.b82c2ba3.js.map"
    key                    = "ui.b82c2ba3.js.map"
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.b82c2ba3.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "qlo6HXIVoHHmoRe7jTc2uPwe2g5FUFrx"
}

# aws_s3_object.website_files["ui.d119b665.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.d119b665.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "5ac440bda819fad729551a3c52f8b9b9"
    force_destroy          = false
    id                     = "ui.d119b665.js"
    key                    = "ui.d119b665.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.d119b665.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "CCpTPeZi0Y5Mu6jTAQZOv.qxK1K53Laz"
}

# aws_s3_object.website_files["ui.d119b665.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.d119b665.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "517bef80e4a43d19feb4c2dad09b5710-2"
    force_destroy          = false
    id                     = "ui.d119b665.js.map"
    key                    = "ui.d119b665.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.d119b665.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "uSMwLmNaJa7b1xwghH5KAilsbAJziDu7"
}

# aws_s3_object.website_files["ui.ee3dfc51.js"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.ee3dfc51.js"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/javascript"
    etag                   = "50e0bef214f9a8064d4de2c15614670f"
    force_destroy          = false
    id                     = "ui.ee3dfc51.js"
    key                    = "ui.ee3dfc51.js"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.ee3dfc51.js"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["ui.ee3dfc51.js.map"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/ui.ee3dfc51.js.map"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "application/octet-stream"
    etag                   = "3ab313132e57709c6cb8c46431a386b5"
    force_destroy          = false
    id                     = "ui.ee3dfc51.js.map"
    key                    = "ui.ee3dfc51.js.map"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//ui.ee3dfc51.js.map"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["unfold_more.1f608602.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/unfold_more.1f608602.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "6020c06854b7cbe641066b9291ac9e77"
    force_destroy          = false
    id                     = "unfold_more.1f608602.svg"
    key                    = "unfold_more.1f608602.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//unfold_more.1f608602.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["unfold_more.46c00529.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/unfold_more.46c00529.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "acf8696ec8949f878b06bb19da32f1fb"
    force_destroy          = false
    id                     = "unfold_more.46c00529.svg"
    key                    = "unfold_more.46c00529.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//unfold_more.46c00529.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["us_flag_small.9c3c6ab8.png"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/us_flag_small.9c3c6ab8.png"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/png"
    etag                   = "ab5090f5b92619c69a7dd2e2ee05b3e5"
    force_destroy          = false
    id                     = "us_flag_small.9c3c6ab8.png"
    key                    = "us_flag_small.9c3c6ab8.png"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//us_flag_small.9c3c6ab8.png"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["us_flag_small.e642a40d.png"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/us_flag_small.e642a40d.png"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/png"
    etag                   = "ab5090f5b92619c69a7dd2e2ee05b3e5"
    force_destroy          = false
    id                     = "us_flag_small.e642a40d.png"
    key                    = "us_flag_small.e642a40d.png"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//us_flag_small.e642a40d.png"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["warning.4cc8d763.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/warning.4cc8d763.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "2d22a8d3f2aef0ce4599b699f3807e72"
    force_destroy          = false
    id                     = "warning.4cc8d763.svg"
    key                    = "warning.4cc8d763.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//warning.4cc8d763.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_s3_object.website_files["warning.ce0fedc9.svg"]:
resource "aws_s3_object" "website_files" {
    arn                    = "arn:aws:s3:::document-extractor-dev-website-328307993388/warning.ce0fedc9.svg"
    bucket                 = "document-extractor-dev-website-328307993388"
    bucket_key_enabled     = false
    content_type           = "image/svg+xml"
    etag                   = "93b6b1635a5809f74f86425e3344a32d"
    force_destroy          = false
    id                     = "warning.ce0fedc9.svg"
    key                    = "warning.ce0fedc9.svg"
    metadata               = {}
    server_side_encryption = "AES256"
    source                 = "./../ui/dist//warning.ce0fedc9.svg"
    storage_class          = "STANDARD"
    tags                   = {
        "project" = "document-extractor"
    }
    tags_all               = {
        "project" = "document-extractor"
    }
    version_id             = "null"
}

# aws_secretsmanager_secret.password:
resource "aws_secretsmanager_secret" "password" {
    arn                            = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-password-5KgJiD"
    force_overwrite_replica_secret = false
    id                             = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-password-5KgJiD"
    name                           = "document-extractor-dev-password"
    recovery_window_in_days        = 30
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
}

# aws_secretsmanager_secret.private_key:
resource "aws_secretsmanager_secret" "private_key" {
    arn                            = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-private-key-PI2EsC"
    force_overwrite_replica_secret = false
    id                             = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-private-key-PI2EsC"
    name                           = "document-extractor-dev-private-key"
    recovery_window_in_days        = 30
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
}

# aws_secretsmanager_secret.public_key:
resource "aws_secretsmanager_secret" "public_key" {
    arn                            = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-public-key-PI2EsC"
    force_overwrite_replica_secret = false
    id                             = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-public-key-PI2EsC"
    name                           = "document-extractor-dev-public-key"
    recovery_window_in_days        = 30
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
}

# aws_secretsmanager_secret.username:
resource "aws_secretsmanager_secret" "username" {
    arn                            = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-username-gKcWPC"
    force_overwrite_replica_secret = false
    id                             = "arn:aws:secretsmanager:us-west-1:328307993388:secret:document-extractor-dev-username-gKcWPC"
    name                           = "document-extractor-dev-username"
    recovery_window_in_days        = 30
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
}

# aws_sqs_queue.queue_to_dynamo:
resource "aws_sqs_queue" "queue_to_dynamo" {
    arn                               = "arn:aws:sqs:us-west-1:328307993388:document-extractor-dev-to-dynamodb"
    content_based_deduplication       = false
    delay_seconds                     = 0
    fifo_queue                        = false
    id                                = "https://sqs.us-west-1.amazonaws.com/328307993388/document-extractor-dev-to-dynamodb"
    kms_data_key_reuse_period_seconds = 300
    kms_master_key_id                 = "2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    max_message_size                  = 262144
    message_retention_seconds         = 345600
    name                              = "document-extractor-dev-to-dynamodb"
    receive_wait_time_seconds         = 0
    sqs_managed_sse_enabled           = false
    tags                              = {}
    tags_all                          = {
        "project" = "document-extractor-dev"
    }
    url                               = "https://sqs.us-west-1.amazonaws.com/328307993388/document-extractor-dev-to-dynamodb"
    visibility_timeout_seconds        = 30
}

# null_resource.invalidate_cloudfront:
resource "null_resource" "invalidate_cloudfront" {
    id       = "8325867666043885233"
    triggers = {
        "always_run" = "2025-05-22T21:19:22Z"
    }
}


# module.document_endpoints.data.aws_api_gateway_rest_api.api:
data "aws_api_gateway_rest_api" "api" {
    api_key_source         = "HEADER"
    arn                    = "arn:aws:apigateway:us-west-1::/restapis/ic9avcgf3l"
    binary_media_types     = []
    description            = "document-extractor API"
    endpoint_configuration = [
        {
            ip_address_type  = "ipv4"
            types            = [
                "EDGE",
            ]
            vpc_endpoint_ids = []
        },
    ]
    execution_arn          = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l"
    id                     = "ic9avcgf3l"
    name                   = "document-extractor-dev-api"
    root_resource_id       = "qdlfjof80i"
    tags                   = {
        "project" = "document-extractor-dev"
    }
}

# module.document_endpoints.aws_api_gateway_integration.lambda_integration[0]:
resource "aws_api_gateway_integration" "lambda_integration" {
    cache_key_parameters    = []
    cache_namespace         = "ljz2z9"
    connection_type         = "INTERNET"
    http_method             = "POST"
    id                      = "agi-ic9avcgf3l-ljz2z9-POST"
    integration_http_method = "POST"
    passthrough_behavior    = "WHEN_NO_MATCH"
    request_parameters      = {}
    request_templates       = {}
    resource_id             = "ljz2z9"
    rest_api_id             = "ic9avcgf3l"
    timeout_milliseconds    = 29000
    type                    = "AWS_PROXY"
    uri                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-create-document/invocations"
}

# module.document_endpoints.aws_api_gateway_method.http_method[0]:
resource "aws_api_gateway_method" "http_method" {
    api_key_required     = false
    authorization        = "CUSTOM"
    authorization_scopes = []
    authorizer_id        = "bq0hho"
    http_method          = "POST"
    id                   = "agm-ic9avcgf3l-ljz2z9-POST"
    request_models       = {}
    request_parameters   = {}
    resource_id          = "ljz2z9"
    rest_api_id          = "ic9avcgf3l"
}

# module.document_endpoints.aws_api_gateway_resource.resource_path:
resource "aws_api_gateway_resource" "resource_path" {
    id          = "ljz2z9"
    parent_id   = "qdlfjof80i"
    path        = "/document"
    path_part   = "document"
    rest_api_id = "ic9avcgf3l"
}

# module.document_endpoints.aws_lambda_function.function[0]:
resource "aws_lambda_function" "function" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-create-document"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-create-document"
    handler                        = "src.external.aws.lambdas.s3_file_upload.lambda_handler"
    id                             = "document-extractor-dev-create-document"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-create-document/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:50:25.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-create-document:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-create-document:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = (sensitive value)
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-create-document"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# module.document_endpoints.aws_lambda_permission.api_gateway[0]:
resource "aws_lambda_permission" "api_gateway" {
    action        = "lambda:InvokeFunction"
    function_name = "document-extractor-dev-create-document"
    id            = "AllowExecutionFromApiGateway"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/*/*/*"
    statement_id  = "AllowExecutionFromApiGateway"
}

# module.document_endpoints.aws_lambda_provisioned_concurrency_config.api_function_concurrency[0]:
resource "aws_lambda_provisioned_concurrency_config" "api_function_concurrency" {
    function_name                     = "document-extractor-dev-create-document"
    id                                = "document-extractor-dev-create-document,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}


# module.document_id_endpoints.data.aws_api_gateway_rest_api.api:
data "aws_api_gateway_rest_api" "api" {
    api_key_source         = "HEADER"
    arn                    = "arn:aws:apigateway:us-west-1::/restapis/ic9avcgf3l"
    binary_media_types     = []
    description            = "document-extractor API"
    endpoint_configuration = [
        {
            ip_address_type  = "ipv4"
            types            = [
                "EDGE",
            ]
            vpc_endpoint_ids = []
        },
    ]
    execution_arn          = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l"
    id                     = "ic9avcgf3l"
    name                   = "document-extractor-dev-api"
    root_resource_id       = "qdlfjof80i"
    tags                   = {
        "project" = "document-extractor-dev"
    }
}

# module.document_id_endpoints.aws_api_gateway_integration.lambda_integration[0]:
resource "aws_api_gateway_integration" "lambda_integration" {
    cache_key_parameters    = []
    cache_namespace         = "g3ywx2"
    connection_type         = "INTERNET"
    http_method             = "GET"
    id                      = "agi-ic9avcgf3l-g3ywx2-GET"
    integration_http_method = "POST"
    passthrough_behavior    = "WHEN_NO_MATCH"
    request_parameters      = {}
    request_templates       = {}
    resource_id             = "g3ywx2"
    rest_api_id             = "ic9avcgf3l"
    timeout_milliseconds    = 29000
    type                    = "AWS_PROXY"
    uri                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-get-document/invocations"
}

# module.document_id_endpoints.aws_api_gateway_integration.lambda_integration[1]:
resource "aws_api_gateway_integration" "lambda_integration" {
    cache_key_parameters    = []
    cache_namespace         = "g3ywx2"
    connection_type         = "INTERNET"
    http_method             = "PUT"
    id                      = "agi-ic9avcgf3l-g3ywx2-PUT"
    integration_http_method = "POST"
    passthrough_behavior    = "WHEN_NO_MATCH"
    request_parameters      = {}
    request_templates       = {}
    resource_id             = "g3ywx2"
    rest_api_id             = "ic9avcgf3l"
    timeout_milliseconds    = 29000
    type                    = "AWS_PROXY"
    uri                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-update-document/invocations"
}

# module.document_id_endpoints.aws_api_gateway_method.http_method[0]:
resource "aws_api_gateway_method" "http_method" {
    api_key_required     = false
    authorization        = "CUSTOM"
    authorization_scopes = []
    authorizer_id        = "bq0hho"
    http_method          = "GET"
    id                   = "agm-ic9avcgf3l-g3ywx2-GET"
    request_models       = {}
    request_parameters   = {}
    resource_id          = "g3ywx2"
    rest_api_id          = "ic9avcgf3l"
}

# module.document_id_endpoints.aws_api_gateway_method.http_method[1]:
resource "aws_api_gateway_method" "http_method" {
    api_key_required     = false
    authorization        = "CUSTOM"
    authorization_scopes = []
    authorizer_id        = "bq0hho"
    http_method          = "PUT"
    id                   = "agm-ic9avcgf3l-g3ywx2-PUT"
    request_models       = {}
    request_parameters   = {}
    resource_id          = "g3ywx2"
    rest_api_id          = "ic9avcgf3l"
}

# module.document_id_endpoints.aws_api_gateway_resource.resource_path:
resource "aws_api_gateway_resource" "resource_path" {
    id          = "g3ywx2"
    parent_id   = "ljz2z9"
    path        = "/document/{document_id}"
    path_part   = "{document_id}"
    rest_api_id = "ic9avcgf3l"
}

# module.document_id_endpoints.aws_lambda_function.function[0]:
resource "aws_lambda_function" "function" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-get-document"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-get-document"
    handler                        = "src.external.aws.lambdas.get_extracted_document.lambda_handler"
    id                             = "document-extractor-dev-get-document"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-get-document/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:49:55.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-get-document:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-get-document:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = (sensitive value)
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-get-document"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# module.document_id_endpoints.aws_lambda_function.function[1]:
resource "aws_lambda_function" "function" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-update-document"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-update-document"
    handler                        = "src.external.aws.lambdas.update_extracted_document.lambda_handler"
    id                             = "document-extractor-dev-update-document"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-update-document/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:49:31.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-update-document:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-update-document:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = (sensitive value)
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-update-document"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# module.document_id_endpoints.aws_lambda_permission.api_gateway[0]:
resource "aws_lambda_permission" "api_gateway" {
    action        = "lambda:InvokeFunction"
    function_name = "document-extractor-dev-get-document"
    id            = "AllowExecutionFromApiGateway"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/*/*/*"
    statement_id  = "AllowExecutionFromApiGateway"
}

# module.document_id_endpoints.aws_lambda_permission.api_gateway[1]:
resource "aws_lambda_permission" "api_gateway" {
    action        = "lambda:InvokeFunction"
    function_name = "document-extractor-dev-update-document"
    id            = "AllowExecutionFromApiGateway"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/*/*/*"
    statement_id  = "AllowExecutionFromApiGateway"
}

# module.document_id_endpoints.aws_lambda_provisioned_concurrency_config.api_function_concurrency[0]:
resource "aws_lambda_provisioned_concurrency_config" "api_function_concurrency" {
    function_name                     = "document-extractor-dev-get-document"
    id                                = "document-extractor-dev-get-document,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}

# module.document_id_endpoints.aws_lambda_provisioned_concurrency_config.api_function_concurrency[1]:
resource "aws_lambda_provisioned_concurrency_config" "api_function_concurrency" {
    function_name                     = "document-extractor-dev-update-document"
    id                                = "document-extractor-dev-update-document,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}


# module.token_endpoints.data.aws_api_gateway_rest_api.api:
data "aws_api_gateway_rest_api" "api" {
    api_key_source         = "HEADER"
    arn                    = "arn:aws:apigateway:us-west-1::/restapis/ic9avcgf3l"
    binary_media_types     = []
    description            = "document-extractor API"
    endpoint_configuration = [
        {
            ip_address_type  = "ipv4"
            types            = [
                "EDGE",
            ]
            vpc_endpoint_ids = []
        },
    ]
    execution_arn          = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l"
    id                     = "ic9avcgf3l"
    name                   = "document-extractor-dev-api"
    root_resource_id       = "qdlfjof80i"
    tags                   = {
        "project" = "document-extractor-dev"
    }
}

# module.token_endpoints.aws_api_gateway_integration.lambda_integration[0]:
resource "aws_api_gateway_integration" "lambda_integration" {
    cache_key_parameters    = []
    cache_namespace         = "dmuib4"
    connection_type         = "INTERNET"
    http_method             = "POST"
    id                      = "agi-ic9avcgf3l-dmuib4-POST"
    integration_http_method = "POST"
    passthrough_behavior    = "WHEN_NO_MATCH"
    request_parameters      = {}
    request_templates       = {}
    resource_id             = "dmuib4"
    rest_api_id             = "ic9avcgf3l"
    timeout_milliseconds    = 29000
    type                    = "AWS_PROXY"
    uri                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-token/invocations"
}

# module.token_endpoints.aws_api_gateway_method.http_method[0]:
resource "aws_api_gateway_method" "http_method" {
    api_key_required     = false
    authorization        = "NONE"
    authorization_scopes = []
    http_method          = "POST"
    id                   = "agm-ic9avcgf3l-dmuib4-POST"
    request_models       = {}
    request_parameters   = {}
    resource_id          = "dmuib4"
    rest_api_id          = "ic9avcgf3l"
}

# module.token_endpoints.aws_api_gateway_resource.resource_path:
resource "aws_api_gateway_resource" "resource_path" {
    id          = "dmuib4"
    parent_id   = "qdlfjof80i"
    path        = "/token"
    path_part   = "token"
    rest_api_id = "ic9avcgf3l"
}

# module.token_endpoints.aws_lambda_function.function[0]:
resource "aws_lambda_function" "function" {
    architectures                  = [
        "arm64",
    ]
    arn                            = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-token"
    code_sha256                    = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    filename                       = "./../backend/dist/lambda.zip"
    function_name                  = "document-extractor-dev-token"
    handler                        = "src.external.aws.lambdas.token.lambda_handler"
    id                             = "document-extractor-dev-token"
    invoke_arn                     = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-token/invocations"
    kms_key_arn                    = "arn:aws:kms:us-west-1:328307993388:key/2c84ed0b-7d29-4d92-ab32-f0db5557a13c"
    last_modified                  = "2025-05-22T20:49:10.000+0000"
    layers                         = []
    memory_size                    = 256
    package_type                   = "Zip"
    publish                        = true
    qualified_arn                  = "arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-token:5"
    qualified_invoke_arn           = "arn:aws:apigateway:us-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-1:328307993388:function:document-extractor-dev-token:5/invocations"
    reserved_concurrent_executions = -1
    role                           = "arn:aws:iam::328307993388:role/document-extractor-dev-lambda-execution-role"
    runtime                        = "python3.13"
    skip_destroy                   = false
    source_code_hash               = "7hfzRPB44Pnra9oswy/9jJGr2iFhrg+RYqaU5cOuc9o="
    source_code_size               = 19659547
    tags                           = {}
    tags_all                       = {
        "project" = "document-extractor-dev"
    }
    timeout                        = 30
    version                        = "5"

    environment {
        variables = (sensitive value)
    }

    ephemeral_storage {
        size = 512
    }

    logging_config {
        log_format = "Text"
        log_group  = "/aws/lambda/document-extractor-dev-token"
    }

    tracing_config {
        mode = "PassThrough"
    }
}

# module.token_endpoints.aws_lambda_permission.api_gateway[0]:
resource "aws_lambda_permission" "api_gateway" {
    action        = "lambda:InvokeFunction"
    function_name = "document-extractor-dev-token"
    id            = "AllowExecutionFromApiGateway"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "arn:aws:execute-api:us-west-1:328307993388:ic9avcgf3l/*/*/*"
    statement_id  = "AllowExecutionFromApiGateway"
}

# module.token_endpoints.aws_lambda_provisioned_concurrency_config.api_function_concurrency[0]:
resource "aws_lambda_provisioned_concurrency_config" "api_function_concurrency" {
    function_name                     = "document-extractor-dev-token"
    id                                = "document-extractor-dev-token,5"
    provisioned_concurrent_executions = 1
    qualifier                         = "5"
    skip_destroy                      = false
}


Outputs:

distribution_id = "ENWTZLUASCDJZ"

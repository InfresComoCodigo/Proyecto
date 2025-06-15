###############################################################################
# Datos de región y cuenta
###############################################################################
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

###############################################################################
# Locales
###############################################################################
locals {
  lambda_source_dir = var.source_path != "" ? var.source_path : "${path.module}/../../../../src/lambda_usuarios"
  lambda_zip_path   = "${path.module}/build/${var.function_name}.zip"
}

###############################################################################
# Empaquetar código
###############################################################################
data "archive_file" "zip" {
  type        = "zip"
  source_dir  = local.lambda_source_dir
  output_path = local.lambda_zip_path
}

###############################################################################
# IAM
###############################################################################
data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  # Acceso a la tabla DynamoDB
  statement {
    sid     = "DynamoDBWrite"
    effect  = "Allow"
    actions = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
    ]
  }

  # Acceso a CloudWatch Logs
  statement {
    sid     = "CloudWatchLogs"
    effect  = "Allow"
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "inline" {
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.policy.json
}

###############################################################################
# CloudWatch Log Group para los logs de la Lambda
###############################################################################
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  # checkov:skip=CKV_AWS_338: Retención definida en 14 días por política interna de Villa Alfredo
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
  kms_key_id        = var.kms_key_arn
  
  tags = {
    project     = "Villa Alfredo"
    environment = terraform.workspace
  }
}


###############################################################################
# Lambda
###############################################################################
resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  runtime          = var.runtime
  handler          = var.handler

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  memory_size      = var.memory_size
  timeout          = var.timeout

  environment {
    variables = {
      USERS_TABLE = var.dynamodb_table_name
    }
  }

  tags = {
    project     = "Villa Alfredo"
    environment = terraform.workspace
  }

  # Hacer referencia al Log Group ya creado en lugar de crear un ciclo
  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}

###############################################################################
# Permiso para API Gateway
###############################################################################
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = var.api_execution_arn != "" ? "${var.api_execution_arn}/*/usuarios*" : "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*/*/usuarios*"
}

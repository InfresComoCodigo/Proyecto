###############################################################################
# Datos de región y cuenta
###############################################################################
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

###############################################################################
# Locales
###############################################################################
locals {
  lambda_source_dir = var.source_path != "" ? var.source_path: "${path.module}/../../../../src/lambda_usuarios"

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
  # Acceso a la tabla
  statement {
    sid     = "DynamoDBWrite"
    effect  = "Allow"
    actions = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
    ]
  }

  # Logs
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
}

###############################################################################
# Permiso para API Gateway
###############################################################################
# Permiso para que API Gateway invoque la Lambda
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = var.api_execution_arn != "" ?"${var.api_execution_arn}/*/usuarios*" :"arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*/*/usuarios*"
}
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.lambda_role_arn
  runtime       = var.runtime
  handler       = var.handler

  timeout      = 15
  memory_size  = 256

  filename         = "${path.module}/lambda-function-payload.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda-function-payload.zip")

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.default_sg_id]
  }

  environment {
    variables = {
      DB_CLUSTER_ARN = var.aurora_cluster_arn
      DB_SECRET_ARN  = var.aurora_secret_arn
      DB_NAME        = "villa-alfredo-db"
    }
  }
}

resource "aws_api_gateway_rest_api" "pago_api" {
  name        = "${var.function_name}-api"
  description = "API Gateway conectado a Lambda en subred privada"
}

resource "aws_api_gateway_resource" "pago" {
  rest_api_id = aws_api_gateway_rest_api.pago_api.id
  parent_id   = aws_api_gateway_rest_api.pago_api.root_resource_id
  path_part   = "pagar"
}

resource "aws_api_gateway_method" "post_pago" {
  rest_api_id   = aws_api_gateway_rest_api.pago_api.id
  resource_id   = aws_api_gateway_resource.pago.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.pago_api.id
  resource_id             = aws_api_gateway_resource.pago.id
  http_method             = aws_api_gateway_method.post_pago.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

# ✅ Eliminamos el stage_name de aquí (ya no recomendado)
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.pago_api.id
}

# ✅ Creamos el recurso moderno para el stage "prod"
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.pago_api.id
  stage_name    = "prod"
}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.pago_api.execution_arn}/*/*"
}
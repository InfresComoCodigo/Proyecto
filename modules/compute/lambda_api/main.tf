# Empaqueta el codigo de la función Lambda
data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = var.source_path
    output_path = "${path.module}/lambda.zip"
}

################################################################################

# IAM role + policy basica
resource "aws_iam_role" "lambda_exec" {
    name               = "${var.function_name}-role"
    assume_role_policy = data.aws_iam_policy_document.assume_lambda.json 
    tags               = var.tags
}


## Genera la política JSON inline:
data "aws_iam_policy_document" "assume_lambda" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
        }
    }
}


## Adjunta a ese rol la policy gestionada que da permisos para escribir logs en CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role       = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

################################################################################

# Lambda Function
resource "aws_lambda_function" "this" {
    function_name    = var.function_name
    role             = aws_iam_role.lambda_exec.arn
    runtime          = var.runtime
    handler          = var.handler
    filename         = data.archive_file.lambda_zip.output_path
    memory_size      = var.memory_size
    timeout          = var.timeout
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256

    environment {
        variables = var.environment
    }

    tags = var.tags
}

################################################################################

# API GATEWAY (REST) -> Lambda proxy
resource "aws_api_gateway_rest_api" "api" { # Crea una REST API en API Gateway.
    name = "${var.function_name}-api"
    endpoint_configuration { types = ["EDGE"] } # Distribución global con CloudFront gestionada por AWS.
    tags = var.tags
}

## Agrega un recurso dinámico /{proxy+} que captura cualquier ruta.
resource "aws_api_gateway_resource" "root" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "{proxy+}"
}

## Define el método ANY (GET, POST, etc.) sin autorización (por ahora).
resource "aws_api_gateway_method" "proxy" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.root.id
    http_method   = "ANY"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.root.id
    http_method = aws_api_gateway_method.proxy.http_method

    integration_http_method = "POST"
    type                    = "AWS_PROXY" # Integración proxy: pasa el evento HTTP tal cual a Lambda y devuelve su respuesta.
    uri                     = aws_lambda_function.this.invoke_arn # ARN especial de invocación de la Lambda.
}

## Publica la API en el stage v1. depends_on garantiza que la integración esté lista antes de desplegar.
resource "aws_api_gateway_deployment" "deploy" {
    depends_on  = [aws_api_gateway_integration.lambda]
    rest_api_id = aws_api_gateway_rest_api.api.id
    # stage_name  = "v1"
    #stage_description = "Initial stage"
}

################################################################################

# Permiso para que API GW invoque la Lambda
resource "aws_lambda_permission" "apigw" {
    statement_id  = "AllowAPIGWInvoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.this.function_name
    principal     = "apigateway.amazonaws.com"  # Identifica el servicio.
    source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*" # Restringe la invocación a tu REST API concreta.
}
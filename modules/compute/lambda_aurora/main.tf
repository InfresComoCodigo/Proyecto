resource "aws_lambda_function" "this" {
    function_name = var.function_name
    role          = var.lambda_role_arn
    runtime       = var.runtime
    handler       = var.handler

    timeout = 15   # segundos
    memory_size = 256  # opcional: mejora el rendimiento

    filename         = "${path.module}/lambda-function-payload.zip"
    source_code_hash = filebase64sha256("${path.module}/lambda-function-payload.zip")

    vpc_config {
        subnet_ids         = var.subnet_ids         # ← subredes default
        security_group_ids = [var.default_sg_id]    # ← SG default
    }

    environment {
        variables = {
            DB_CLUSTER_ARN = var.aurora_cluster_arn
            DB_SECRET_ARN  = var.aurora_secret_arn
            DB_NAME        = "villa-alfredo-db"
        }
    }
}
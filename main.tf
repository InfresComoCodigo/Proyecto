module "lambda_api" {
    source = "./modules/compute/lambda_api"

    function_name = "villa-alfredo-api"
    runtime       = "python3.12"
    handler       = "handler.lambda_handler"
    source_path   = "${path.module}/modules/compute/lambda_api/src"

    environment = {
        STAGE = var.environment
    }

    tags = {
        project     = "villa-alfredo"
        environment = var.environment
        layer       = "compute"
    }
}

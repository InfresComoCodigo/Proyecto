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

## S3 + cloudfront

module "static_site" {
  source             = "./modules/storage/s3_cloudfront"
  bucket_name        = var.bucket_name
  api_gateway_domain = module.lambda_api.api_gateway_domain
}
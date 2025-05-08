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

# Recursos DEFAULT
data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

data "aws_security_group" "default_sg" {
    filter {
        name   = "group-name"
        values = ["default"]
    }
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

locals {
    default_subnet_ids = data.aws_subnets.default_subnets.ids
    default_sg_id      = data.aws_security_group.default_sg.id
}

# Aurora Serverless
module "aurora" {
    source                 = "./modules/database/aurora_serverless"
    db_name                = "villa_alfredo_db"
    db_username            = var.db_username
    db_password            = var.db_password
    subnet_ids             = local.default_subnet_ids
    default_sg_id          = local.default_sg_id
}

# IAM Role
module "iam" {
    source = "./modules/security/iam"
}

# Lambda Aurora
module "lambda_aurora" {
    source              = "./modules/compute/lambda_aurora"
    function_name       = "lambda-aurora-${terraform.workspace}"
    lambda_role_arn     = module.iam.lambda_role_arn
    aurora_cluster_arn  = module.aurora.cluster_arn
    aurora_secret_arn   = module.aurora.secret_arn
    subnet_ids          = local.default_subnet_ids
    default_sg_id       = local.default_sg_id
}

module "eventbridge_scheduler" {
  source              = "./modules/integration/eventbridge_scheduler"
  lambda_arn          = module.lambda_api.lambda_arn # o lambda_aurora
  schedule_expression = "rate(5 minutes)"
}

module "api_gateway_http" {
  source = "./modules/compute/api_gateway_http"
  api_name             = "my-api-http"
  lambda_invoke_arn    = module.lambda_api.lambda_invoke_arn  # O como hayas definido tu Lambda
  lambda_function_name = module.lambda_api.lambda_function_name
}

output "api_url" {
  value = module.api_gateway_http.api_endpoint
 }
  
## S3 + cloudfront
module "static_site" {
  source      = "./modules/storage/s3_cloudfront"
  bucket_name = var.bucket_name
}
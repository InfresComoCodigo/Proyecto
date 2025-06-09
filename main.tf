# ========================================
# main.tf (raíz del proyecto)
# Arquitectura base para Villa Alfredo
# ========================================

# -------------------------------
# 1. Generar un nombre único para el bucket S3
# -------------------------------
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  final_bucket_name = "villa-alfredo-static-site-${random_id.bucket_suffix.hex}"
}

# -------------------------------
# 2. Crear la API HTTP en API Gateway
# -------------------------------
module "api_gateway" {
  source = "./modules/api/api_gateway"
}

# -------------------------------
# 3. Crear el WAF (Web Application Firewall)
# -------------------------------
module "waf" {
  source      = "./modules/edge/waf"
  environment = var.environment
}

# -------------------------------
# 4. Crear la distribución CloudFront con origen S3 y ruta /api/* al API Gateway
# Se asocia el WAF a esta distribución
# -------------------------------
module "s3_cloudfront" {
  source             = "./modules/edge/s3_cloudfront"
  bucket_name        = local.final_bucket_name
  api_gateway_domain = module.api_gateway.api_domain_name
  waf_acl_arn        = module.waf.web_acl_arn
}

# -------------------------------
# 5. Outputs para exponer la URL del sitio y del API
# -------------------------------
output "cloudfront_distribution_url" {
  description = "URL pública de la distribución CloudFront"
  value       = module.s3_cloudfront.cloudfront_url
}

output "api_gateway_domain" {
  description = "URL del endpoint HTTP API Gateway"
  value       = module.api_gateway.api_domain_name
}


# -------------------------------
# IMPLEMENTACON DE LA FUNCIÓN LAMBDA_USUARIOS
# -------------------------------

module "lambda_usuarios" {
  source = "./modules/compute/lambda_usuarios"

  # Ruta real al código Node.js
  source_path = "${path.root}/src/lambda_usuarios"

  # Parámetros clave
  function_name       = "usuarios-handler-dev"

  dynamodb_table_name = module.usuarios_table.table_name

  # (opcional) restringe aún más el permiso
  # api_execution_arn = module.api_gateway.execution_arn
}

# -------------------------------
# DYNAMODB PARA USUARIOS
# -------------------------------
########################################
# 0) Tabla DynamoDB de usuarios
########################################
module "usuarios_table" {
  source      = "./modules/data/dynamodb"
  table_name  = "usuarios"   # pon otro nombre si prefieres
  hash_key    = "dni"
}
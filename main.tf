# S3 + CloudFront
module "static_site" {
  source             = "./modules/storage/s3_cloudfront"
  bucket_name        = var.bucket_name
  api_gateway_domain = module.lambda_api.api_gateway_domain
}
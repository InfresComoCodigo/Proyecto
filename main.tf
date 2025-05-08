
## S3 + cloudfront
module "static_site" {
  source      = "./modules/storage/s3_cloudfront"
  bucket_name = var.bucket_name
}

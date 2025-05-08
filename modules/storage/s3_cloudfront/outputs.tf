output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.static_site_config.website_endpoint
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

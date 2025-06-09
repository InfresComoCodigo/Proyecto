variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "api_gateway_domain" {
  description = "API Gateway domain name"
  type        = string
}

variable "waf_acl_arn" {
  description = "ARN del WebACL de WAF"
  type        = string
}


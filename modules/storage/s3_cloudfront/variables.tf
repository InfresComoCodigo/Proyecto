variable "bucket_name" {
  default = "evento-static-site-2025-demo"
}

variable "api_gateway_domain" {
  description = "Dominio base del API Gateway sin https://"
  type        = string
}

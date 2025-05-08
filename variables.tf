variable "aws_region" {
    description = "AWS la region se desplegara la infraestructura"
    type        = string
}

variable "environment" {
    description = "Entorno de despliegue (dev, staging, prod)"
    type        = string
}


variable "bucket_name" {
  description = "Nombre del bucket del sitio estático"
  type        = string
  default     = "evento-static-site-2025-demo"
}
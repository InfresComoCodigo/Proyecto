variable "aws_region" {
    description = "AWS la region se desplegara la infraestructura"
    type        = string
}

variable "environment" {
    description = "Entorno de despliegue (dev, staging, prod)"
    type        = string
}
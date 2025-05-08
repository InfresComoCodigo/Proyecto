variable "aws_region" {
    description = "AWS la region se desplegara la infraestructura"
    type        = string
}

variable "environment" {
    description = "Entorno de despliegue (dev, staging, prod)"
    type        = string
}

variable "db_username" {
    description = "Nombre de usuario de la base de datos"
    type        = string
}

variable "db_password" {
    description = "Contraseña de la base de datos"
    type        = string
}
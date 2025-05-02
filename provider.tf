terraform {
    # Versión mínima de Terraform que admite tu código
    required_version = ">= 1.6"
    
    # Proveedores que se descargarán en `terraform init`
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Proveedor de AWS
provider "aws" {
    # Región de AWS donde se desplegarán los recursos
    region = var.aws_region

    default_tags {
        # Etiquetas por defecto que se aplicarán a todos los recursos
        tags = {
            project = "Villa Alfredo"
            environment = var.environment
        }
    }
}
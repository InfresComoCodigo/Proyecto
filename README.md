# Proyecto_IaC

**Integrantes**
- Aguilar Alayo ALessia
- Donayre Alvarez Jose
- Fernandez Gutierrez Valentin
- Leon Rojas Franco
- Moreno Quevedo Camila

Proyecto de `IaC`

Teniendo en cuenta dicha estructura del proyecto

```plaintext
/infraestructura-aws/
├── main.tf                 # Orquesta cada módulo
├── provider.tf             # AWS + versiones Terraform
├── versions.tf             # required_providers y versionado
├── variables.tf            # Región, etiquetas, nombres lógicos
├── terraform.tfvars        # Valores por ambiente (dev por defecto)
├── outputs.tf              # URL CloudFront, ARNs de API, SNS, etc.
└── modules/
    ├── edge/
    │   ├── route53/            # Zona + registros A/AAAA/CNAME
    │   ├── s3_cloudfront/      # Bucket estático + distribución
    │   └── waf/                # Web ACL y asociación a CloudFront
    ├── api/
    │   └── api_gateway/        # REST/HTTP API + CORS
    ├── compute/
    │   ├── lambda_core/        # Layer con libs comunes
    │   ├── lambda_usuarios/
    │   ├── lambda_reserva_local/
    │   ├── lambda_eventos/
    │   ├── lambda_pagos/       # Invoca pasarela de pagos externa
    │   ├── lambda_notificaciones/   # Publica en SNS
    │   └── lambda_envia_notif/      # Lee SNS y llama a Twilio
    ├── data/
    │   └── dynamodb/           # Tablas + GSIs
    ├── messaging/
    │   └── sns/                # Topic + políticas
    ├── networking/
    │   └── vpc_public/         # VPC + subnet pública (simple)
    ├── monitoring/
    │   ├── grafana_docker/     # Receta Docker Compose
    │   └── cloudwatch/         
    └── security/
        ├── iam/                # Roles y policies mínimos
        └── sg/                 # Security Groups (por si luego añades algo)

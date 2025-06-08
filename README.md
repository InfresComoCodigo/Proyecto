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
├── main.tf
├── provider.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── modules/
    ├── edge/
    │   ├── route53/               # Zona y registros públicos
    │   ├── waf/                   # Reglas de firewall
    │   └── s3_cloudfront/         # Sitio estático + CDN
    ├── api/
    │   └── api_gateway/           # Puerta de enlace REST/HTTP
    ├── compute/
    │   ├── lambda_core/           # Capa con librerías comunes
    │   ├── lambda_usuarios/
    │   ├── lambda_reserva_local/
    │   ├── lambda_eventos/
    │   ├── lambda_pagos/
    │   ├── lambda_notificaciones/ # Publica en SNS
    │   └── lambda_envia_notif/    # Consume SNS y llama Twilio
    ├── data/
    │   └── dynamodb/              # Tablas e índices
    ├── messaging/
    │   └── sns/                   # Topic + suscripciones
    ├── networking/
    │   └── vpc_public/            # VPC y subnet (por si luego creces)
    └── security/
        ├── iam/                   # Roles/policies finas
        └── sg/                    # Security Groups (si los necesitas)

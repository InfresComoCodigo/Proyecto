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
├── main.tf              # Llama a todos los módulos
├── provider.tf          # Provider + versión Terraform
├── variables.tf         # Variables globales (región, etiquetas, etc.)
├── terraform.tfvars     # Valores por defecto (si quieres)
├── outputs.tf           # URLs, ARNs y IDs que pueda necesitar tu equipo
└── modules/             # Todo lo reutilizable vive aquí
    ├── storage/
    │   └── s3_cloudfront/         # S3 estático + CloudFront
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
    ├── compute/
    │   ├── lambda_api/            # Lambda + API Gateway público
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   └── lambda_aurora/         # Lambda + Aurora Serverless (en subred privada)
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
    ├── integration/
    │   ├── eventbridge_scheduler/ # Scheduler de jobs
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── twilio_whatsapp/       # Webhook/API hacia Twilio
    │       ├── main.tf
    │       └── variables.tf
    ├── networking/
    │   ├── vpc/                   # VPC, subnets, IGW, NAT
    │   │   ├── main.tf
    │   │   └── outputs.tf
    │   ├── transit_gateway/       # TGW + attachments
    │   │   ├── main.tf
    │   │   └── outputs.tf
    │   └── direct_connect/        # Direct Connect + VIFs
    │       ├── main.tf
    │       └── outputs.tf
    ├── edge/
    │   └── waf/                   # AWS WAF ACLs y asociaciones
    │       ├── main.tf
    │       └── variables.tf
    └── security/
        ├── iam/                   # Roles y políticas
        │   ├── main.tf
        │   └── variables.tf
        └── sg/                    # Security Groups y NACL (opcional)
            ├── main.tf
            └── variables.tf

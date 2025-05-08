resource "aws_db_subnet_group" "aurora_subnet_group" {
    name       = "${var.db_name}-default-sng"
    subnet_ids = var.subnet_ids           # ← subredes default
}

resource "aws_rds_cluster" "aurora" {
    cluster_identifier      = replace(lower("${var.db_name}-cluster"), "_", "-")
    engine                  = var.engine
    engine_version          = var.engine_version
    engine_mode             = "provisioned"         # serverless v2
    enable_http_endpoint = true   # Habilita la Data API
    
    database_name  = var.db_name          # nombre de BD interna
    master_username = var.db_username
    master_password = var.db_password

    vpc_security_group_ids  = [var.default_sg_id]   # ← SG default
    db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
    skip_final_snapshot     = true

    serverlessv2_scaling_configuration {
        min_capacity = 0.5
        max_capacity = 4
    }

}

# Secret con credenciales
resource "random_string" "suffix" {
    length  = 4
    special = false
}

resource "aws_secretsmanager_secret" "aurora_secret" {
    name = "${replace(lower(var.db_name), "_", "-")}-cred-${random_string.suffix.result}"
    description = "Credenciales de ${var.db_name}"
}

resource "aws_secretsmanager_secret_version" "aurora_secret_version" {
    secret_id = aws_secretsmanager_secret.aurora_secret.id
    secret_string = jsonencode({
        username = var.db_username
        password = var.db_password
    })
}


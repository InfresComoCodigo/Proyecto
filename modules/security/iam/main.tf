# Este módulo crea un rol y una política de IAM para que una función Lambda acceda a Aurora Serverless.
# Permite que la función Lambda asuma el rol y acceda a AWS Secrets Manager y a la API de datos de RDS.
resource "aws_iam_role" "lambda_aurora_exec" {
    name = "lambda-aurora-execution-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
            Service = "lambda.amazonaws.com"
        }
        }]
    })
}

resource "aws_iam_policy" "lambda_aurora_policy" {
    name = "lambda-aurora-policy"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Action = [
            "secretsmanager:GetSecretValue"
            ],
            Resource = "*"
        },
        {
            Effect = "Allow",
            Action = [
            "rds-data:*"
            ],
            Resource = "*"
        },
        {
            Effect = "Allow",
            Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
            ],
            Resource = "*"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_aurora_attachment" {
    role       = aws_iam_role.lambda_aurora_exec.name
    policy_arn = aws_iam_policy.lambda_aurora_policy.arn
}

# NUEVO: política gestionada que da acceso VPC a Lambda
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_aurora_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
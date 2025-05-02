output "lambda_role_arn" {
    value = aws_iam_role.lambda_aurora_exec.arn
}
output "lambda_arn" { value = aws_lambda_function.this.arn }

output "api_pago_url" {
  value = "https://${aws_api_gateway_rest_api.pago_api.id}.execute-api.${var.aws_region}.amazonaws.com/prod/pagar"
}
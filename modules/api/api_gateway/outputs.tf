output "api_domain_name" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

output "execution_arn" {
  value = aws_apigatewayv2_api.this.execution_arn
}
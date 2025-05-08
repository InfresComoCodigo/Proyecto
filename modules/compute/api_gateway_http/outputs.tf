output "api_endpoint" {
  value       = aws_apigatewayv2_api.http_api.api_endpoint
  description = "URL del API Gateway HTTP API"
}
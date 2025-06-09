########################################
# outputs.tf
########################################
output "table_name" {
  value       = aws_dynamodb_table.this.name
  description = "Nombre real de la tabla creada"
}

output "table_arn" {
  value       = aws_dynamodb_table.this.arn
  description = "ARN completo de la tabla"
}

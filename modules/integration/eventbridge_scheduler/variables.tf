variable "lambda_arn" {
  description = "ARN de la función Lambda que será objetivo del scheduler"
  type        = string
}

variable "schedule_expression" {
  description = "Expresión cron o rate para el scheduler"
  type        = string
}
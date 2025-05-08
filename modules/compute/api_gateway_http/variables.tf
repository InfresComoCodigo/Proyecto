variable "api_name" {
  description = "Nombre del API Gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN de invocación de la Lambda"
  type        = string
}

variable "lambda_function_name" {
  description = "Nombre de la función Lambda"
  type        = string
}
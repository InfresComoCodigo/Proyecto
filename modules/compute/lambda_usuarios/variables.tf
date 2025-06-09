variable "function_name" {
  description = "Nombre lógico de la Lambda"
  type        = string
}

variable "runtime" {
  description = "Runtime AWS"
  type        = string
  default     = "nodejs20.x"
}

variable "handler" {
  description = "Archivo.método de entrada"
  type        = string
  default     = "index.handler"
}

variable "source_path" {
  description = "Ruta local al código fuente (carpeta con index.js)"
  type        = string
}

variable "memory_size" {
  type    = number
  default = 256
}

variable "timeout" {
  type    = number
  default = 10
}

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB de usuarios"
  type        = string
}

# Opcional: Execution ARN del API Gateway para afinar permisos
variable "api_execution_arn" {
  description = "ARN base de ejecución del API Gateway"
  type        = string
  default     = ""
}

variable "log_retention_in_days" {
  description = "Número de días que los logs de Lambda se mantendrán"
  type        = number
  default     = 14  # 14 días por defecto
}

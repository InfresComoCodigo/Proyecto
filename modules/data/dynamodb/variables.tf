########################################
# variables.tf
########################################
variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "hash_key" {
  description = "Clave de partición (Partition Key)"
  type        = string
  default     = "dni"
}

variable "sort_key" {
  description = "Clave de ordenamiento (opcional); deja vacío si no la necesitas"
  type        = string
  default     = ""
}

variable "billing_mode" {
  description = "MODELO DE PAGO: PAY_PER_REQUEST o PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "function_name" {
    description = "Nombre logico de la funcion lambda"
    type        = string
}

variable "runtime" {
    description = "Runtime de la funcion lambda (ej: nodejs20.x, python3.12, etc.)"
    type        = string
}

variable "handler" {
    description = "Archivo y export/funcion que actua como handler de la funcion lambda"
    type        = string
}

variable "source_path" {
    description = "Rutal local al codigo fuente a comprimir"
    type        = string
}

variable "memory_size" {
    description = "Tamaño de la memoria asignada a la funcion lambda (en MB)"
    type        = number
    default     = 256
}

variable "timeout" {
    description = "Tiempo de espera para la funcion lambda (en segundos)"
    type        = number
    default     = 10
}

variable "environment" {
    description = "Mapa de variables de entorno para la funcion lambda"
    type        = map(string)
    default     = {}
}

variable "tags" {
    description = "Etiquetas comunes para la funcion lambda"
    type        = map(string)
    default     = {}
}
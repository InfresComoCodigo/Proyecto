variable "function_name" {}
variable "lambda_role_arn" {}
variable "aurora_cluster_arn" {}
variable "aurora_secret_arn" {}
variable "subnet_ids"          { type = list(string) }
variable "default_sg_id"       { type = string }
variable "runtime"             { default = "nodejs18.x" }
variable "handler"             { default = "index.handler" }
variable "aws_region" {
  description = "Región de AWS"
  type        = string
}
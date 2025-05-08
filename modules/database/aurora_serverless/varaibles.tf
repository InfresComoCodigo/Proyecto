variable "db_name" {}
variable "engine"         { default = "aurora-mysql" }      # o aurora-postgresql
variable "engine_version" { default = "8.0.mysql_aurora.3.08.2" }
variable "subnet_ids"              { type = list(string) }
variable "default_sg_id"           { type = string }
variable "db_username" {}
variable "db_password" {}

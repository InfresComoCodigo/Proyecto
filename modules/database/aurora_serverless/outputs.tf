output "cluster_arn" { value = aws_rds_cluster.aurora.arn }
output "secret_arn"  { value = aws_secretsmanager_secret.aurora_secret.arn }

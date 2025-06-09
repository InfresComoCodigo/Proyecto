output "web_acl_arn" {
  description = "ARN de la Web ACL creada con AWS WAF"
  value       = aws_wafv2_web_acl.this.arn
}

resource "aws_wafv2_web_acl" "this" {
  name        = "villa-alfredo-waf"
  description = "WAF para proteger CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "block-bad-bots"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "wafCommonRules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "villaAlfredoWAF"
    sampled_requests_enabled   = true
  }

  tags = {
    environment = var.environment
    project     = "Villa Alfredo"
  }
}

output "lambda_arn" {
    value = aws_lambda_function.this.arn
}

output "api_url" {
    value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/v1"
}

data "aws_region" "current" {}
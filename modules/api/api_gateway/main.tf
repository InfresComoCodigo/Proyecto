resource "aws_apigatewayv2_api" "this" {
  name          = "villa-alfredo-api"
  protocol_type = "HTTP"
  route_selection_expression = "$request.method $request.path"
  api_key_selection_expression = "$request.header.x-api-key"

  tags = {
    project     = "Villa Alfredo"
    environment = "dev"
  }
}
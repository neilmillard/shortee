resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_resource_id
  path_part   = var.use_case
}

resource "aws_api_gateway_method" "this" {
  rest_api_id      = var.rest_api_id
  resource_id      = aws_api_gateway_resource.this.id
  authorization    = var.api_authorization
  http_method      = var.http_method
  api_key_required = false
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  timeout_milliseconds    = 29000
  uri                     = var.lambda_invoke_arn
}

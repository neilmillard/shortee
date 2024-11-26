output "path" {
  value = aws_api_gateway_resource.this.path
}

output "json-parameters-list" {
  value = [
    jsonencode(aws_api_gateway_resource.this),
    jsonencode(aws_api_gateway_method.this),
    jsonencode(aws_api_gateway_integration.this),
  ]
}

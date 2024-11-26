module "label-public" {
  source  = "cloudposse/label/terraform"
  version = "0.8.0"

  namespace  = "shortee"
  stage      = terraform.workspace
  name       = "api-public"
  attributes = ["public"]
}

resource "aws_api_gateway_rest_api" "public" {
  name = module.label-public.id
  tags = module.label-public.tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

module "resolve_short_url" {
  source             = "./modules/api_route_proxy_rpc"
  lambda_invoke_arn  = aws_lambda_function.proxy.invoke_arn
  parent_resource_id = aws_api_gateway_rest_api.public.root_resource_id
  rest_api_id        = aws_api_gateway_rest_api.public.id
  use_case           = "ResolveShortUrl"
  http_method        = "GET"
  api_authorization  = "NONE"
}

resource "aws_api_gateway_stage" "v1-public" {
  depends_on = [
    aws_cloudwatch_log_group.public_api_log_group
  ]

  stage_name    = "v1"
  rest_api_id   = aws_api_gateway_rest_api.public.id
  deployment_id = aws_api_gateway_deployment.v1-public.id

  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.public_api_log_group.arn
    format = jsonencode(
      {
        caller         = "$context.identity.caller"
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        resourcePath   = "$context.resourcePath"
        responseLength = "$context.responseLength"
        status         = "$context.status"
        user           = "$context.identity.user"
      }
    )
  }
}

resource "aws_api_gateway_method_settings" "v1-public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  stage_name  = aws_api_gateway_stage.v1-public.stage_name
  method_path = "*/*"
  settings {
    logging_level   = "OFF"
    metrics_enabled = true
  }
}

resource "aws_api_gateway_deployment" "v1-public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  triggers = {
    redeployment = sha1(
      join(
        ",",
        concat(
          module.resolve_short_url.json-parameters-list
        )
      )
    )
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "build-api-public" {
  statement_id  = "1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.proxy.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.public.execution_arn}/*"
}

module "label-proxy-lambda" {
  source  = "cloudposse/label/terraform"
  version = "0.8.0"

  namespace = module.label.namespace
  stage     = terraform.workspace
  name      = "proxy-lambda" //this should inherit from the parent module name
}

resource "aws_lambda_function" "proxy" {
  function_name                  = module.label-proxy-lambda.id
  filename                       = "templates/dummy_lambda_payload.zip"
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "python3.11"
  handler                        = "run.lambda_handler"
  reserved_concurrent_executions = 200
  memory_size                    = 512
  timeout                        = 900
  publish                        = true

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = local.lambda_env_vars
  }

  vpc_config {
    security_group_ids = [aws_security_group.proxy_lambda_security_group.id]
    subnet_ids         = module.vpc.private_subnet_ids
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}

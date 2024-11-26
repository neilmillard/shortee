resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/proxy-lambda"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "public_api_log_group" {
  name              = "public-api-access-logs"
  retention_in_days = 5
}

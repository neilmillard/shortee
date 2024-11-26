variable "rest_api_id" {
  type        = string
  description = "id of the api gateway resource"
}
variable "parent_resource_id" {
  type        = string
  description = "the parent resource id. can be the api aws_api_gateway_rest_api's root_resource_id or another resource if you wish to nest resources"
}
variable "use_case" {
  type        = string
  description = "The name of the route i.e. 'testMethod' will make example.com/testmethod"
}
variable "lambda_invoke_arn" {
  type        = string
  description = "the invoke url arn of the target lambda"
}

variable "api_authorization" {
  type        = string
  default     = "AWS_IAM"
  description = "IAM authorization type, can be - NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS."
}

variable "http_method" {
  type        = string
  default     = "POST"
  description = "http method used for this api gateway resource"
}

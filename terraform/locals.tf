locals {
  environment     = terraform.workspace
  lambda_env_vars = {
    ENVIRONMENT = local.environment
  }
}

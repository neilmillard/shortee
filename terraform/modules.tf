module "vpc" {
  source                     = "./modules/vpc"
  aws_account_numbers        = data.aws_caller_identity.current.account_id
  name                       = "${local.environment}-api"
  cidr_block                 = "10.10.8.0/22"
  enable_nat_gateway         = false
  enable_dns_hostnames       = true
  enable_dns_support         = true
  create_interface_endpoints = true
  create_gateway_endpoints   = true
  create_public_subnets      = true
  create_intra_subnets       = true
  environment                = local.environment
  aws_gateway_endpoints      = ["s3", "dynamodb"]
  aws_interface_endpoints = [
    "lambda",
    "logs",
  ]
  tags = {}
}
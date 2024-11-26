data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "label" {
  source  = "cloudposse/label/terraform"
  version = "0.8.0"

  namespace = "mts"
  stage     = terraform.workspace
  name      = "api"
}

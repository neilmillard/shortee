terraform {
  required_version = "~> 1.9.8"

  # update with remote S3 if required
  backend "local" {}

  required_providers {
    aws = ">= 5.76.0"
  }
}
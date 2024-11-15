terraform {
  required_version = "~> 1.9.8"

  backend "s3" {
    key = "shortie/state"
    region = "eu-west-1"
    dynamodb_table = "terraform-shortie"
  }

  required_providers {
    aws = ">= 5.76.0"
  }
}
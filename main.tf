terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  shared_config_files      = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region = "us-west-2"
}

data "aws_s3_bucket" "existing_bucket" {
  count  = var.skip_bucket_creation_if_exists ? 1 : 0
  bucket = var.bucket_name
}

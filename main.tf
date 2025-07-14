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

module "templates_bucket" {
  source        = "./modules/s3_bucket"
  bucket_name   = "yt-extractor-template-7c5a4t"
  force_destroy = true

  tags = {
    Name        = "Nodered Templates"
    Environment = "Dev"
  }
}
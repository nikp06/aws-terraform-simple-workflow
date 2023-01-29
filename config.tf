provider "aws" {

  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Iac     = "cdk"
      Project = "tf-simple-sfn"
    }
  }
}

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
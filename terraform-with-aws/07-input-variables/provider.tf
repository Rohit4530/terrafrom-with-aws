terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.97.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

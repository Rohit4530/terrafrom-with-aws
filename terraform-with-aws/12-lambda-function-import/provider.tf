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
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

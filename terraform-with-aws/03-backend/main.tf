terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.97.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }

  }
  backend "s3" {
    bucket = "rg-devops-infra"
    key = "state.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}
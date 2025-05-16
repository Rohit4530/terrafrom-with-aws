terraform {
  cloud {

    organization = "rg_devops_4530"

    workspaces {
      name = "api-driven-workflow"
    }
  }
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.97.0"
    }
  }
}
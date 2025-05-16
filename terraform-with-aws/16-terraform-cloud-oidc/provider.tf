terraform {
 required_version = "~>1.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.97.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }
  }
  cloud {

    organization = "rg_devops_4530"

    workspaces {
      name = "terraform-cli"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"

  # (Optionnel) Terraform Cloud backend
#   backend "remote" {
#     organization = "ton_organisation_terraform_cloud"
#     workspaces {
#       name = "forum-anonyme"
#     }
#   }
}

provider "aws" {
  region = "eu-central-1"
}

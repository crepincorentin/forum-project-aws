terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"

  cloud {
    organization = "corentin-forum"  # Remplacez par VOTRE organisation
  
    workspaces {
      name = "forum-aws"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

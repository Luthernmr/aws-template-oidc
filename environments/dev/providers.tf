terraform {
  required_version = "~> 1.9.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Use localy stored credentials (ex: .aws/credentials)
  profile = "default"

  # Those are provided by the profile
  # region     = var.provider_region
  # access_key = var.access_key
  # secret_key = var.secret_key
}

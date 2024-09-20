terraform {
  required_version = "~> 1.9.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # Use AWS S3 to synchronize terraform state
  backend "s3" {
    bucket  = "42-cloud-1-terraform-state"
    key     = "state/terraform.tfstate"
    region  = "eu-west-3" # Paris
    encrypt = true

    # This Database has a `LockID` entry to prevent concurent access
    dynamodb_table = "42-cloud-1-terraform-state-lock"
  }
}

provider "aws" {
  # Use localy stored credentials (ex: .aws/credentials)
  profile = "perso"

  # Those are provided by the profile
  # region     = var.provider_region
  # access_key = var.access_key
  # secret_key = var.secret_key
}

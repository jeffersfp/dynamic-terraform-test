variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

terraform {

  backend "s3" {
    # Specify the state file key here or via -backend-config during init
    # key          = "terraform/state/preview-envs/preview/terraform.tfstate"
    bucket       = "my-terraform-state-bucket" # Specify your bucket name here
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.13.0"
}

provider "aws" {
  region = var.aws_region
}

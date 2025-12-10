variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

terraform {

  # Configure the backend (uncomment and modify as needed)
  # backend "s3" {
  #   bucket       = "my-terraform-state-bucket"
  #   key          = "terraform/state/preview-envs/backend/terraform.tfstate"
  #   region       = "us-east-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }

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

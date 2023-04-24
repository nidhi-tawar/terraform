terraform {
  required_version = "~> 1.2.0"

  backend "s3" {
    bucket = "<Bucket_Name>"
    region = "var.bucket_region"

    workspace_key_prefix = "terraform"
    key                  = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "assume_role" {
  type = map(any)
}

#AWS providers
provider "aws" {
  region = var.region

  assume_role {
    role_arn    = var.assume_role["role_arn"]
    external_id = var.assume_role["external_id"]
  }

  default_tags {
    tags = {
      Environment = var.env
      Management  = "Terraform"
    }
  }
}

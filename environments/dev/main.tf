terraform {
  required_version = ">=1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "kpi-tfstate-dev"
    key            = "kpi/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "kpi-tflock-dev"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project    = var.project_name
      Enviorment = var.environment
      ManagedBy  = "terraform"
    }
  }
}

# |-------------VPC------------|
module "vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  project     = var.project
  environment = var.environment
}

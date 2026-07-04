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

#|----------- Subnets -----------|
module "subnets" {
  source               = "../../modules/subnets"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  project              = var.project
  environment          = var.environment
}

#|----------Internet Gateway----------------|
module "internet-gateway" {
  source      = "../../modules/internet-gateway"
  vpc_id      = module.vpc.vpc_id
  project     = var.project
  environment = var.environment
}

# ── Elastic IPs (for NAT Gateways) ───────────────────────────────
module "elastic_ip" {
  source      = "../../modules/elastic-ip"
  count       = length(var.public_subnet_cidrs)
  project     = var.project
  environment = var.environment
}

# ── NAT Gateway ──────────────────────────────────────────────────
module "nat_gateway" {
  source            = "../../modules/nat-gateway"
  public_subnet_ids = module.subnets.public_subnet_ids
  eip_ids           = flatten(module.elastic_ip[*].eip_ids)
  igw_id            = module.internet-gateway.igw_id
  project           = var.project
  environment       = var.environment

  depends_on = [module.internet-gateway]
}

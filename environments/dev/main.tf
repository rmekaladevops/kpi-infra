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

# ── Route Tables ──────────────────────────────────────────────────
module "route_tables" {
  source             = "../../modules/route-tables"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.internet-gateway.igw_id
  nat_gateway_ids    = module.nat_gateway.nat_gateway_ids
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  project            = var.project
  environment        = var.environment
}

# ── Security Groups ───────────────────────────────────────────────
module "security_groups" {
  source            = "../../modules/security-groups"
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = module.vpc.vpc_cidr
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  app_port          = var.app_port
  project           = var.project
  environment       = var.environment
}

# ── Key Pair ──────────────────────────────────────────────────────
module "key_pair" {
  source      = "../../modules/key-pair"
  project     = var.project
  environment = var.environment
}

# ── Bastion Host ──────────────────────────────────────────────────
module "bastion_host" {
  source           = "../../modules/bastion-host"
  public_subnet_id = module.subnets.public_subnet_ids[0]
  bastion_sg_id    = module.security_groups.bastion_sg_id
  key_name         = module.key_pair.key_name
  instance_type    = var.bastion_instance_type
  project          = var.project
  environment      = var.environment
}

# ── IAM ───────────────────────────────────────────────────────────
module "iam" {
  source                  = "../../modules/iam"
  project                 = var.project
  environment             = var.environment
  deployer_principal_arns = var.deployer_principal_arns
}

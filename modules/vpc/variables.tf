variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/int/prod)"
  type        = string
}

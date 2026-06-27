variable "vpc_id" {
  description = "VPC ID where subnets will be created"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR Blocks for private subnets"
  type        = list(string)

}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "project" {
  type = string

}

variable "environment" {
  type = string

}

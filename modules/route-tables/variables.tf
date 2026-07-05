variable "vpc_id" {
  description = "VPC_ID"
  type        = string
}

variable "igw_id" {
  description = "Internet Gateway ID for public route"
  type        = string

}

variable "nat_gateway_ids" {
  description = "List of NAT Gateway IDs for private routes"
  type        = list(string)

}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to associate"
  type        = list(string)

}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to associate"
  type        = list(string)

}

variable "project" {
  description = "project-name"
  type        = string

}
variable "environment" {
  description = "Environment name (dev/int/prod)"
  type        = string

}

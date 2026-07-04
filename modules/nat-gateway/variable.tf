variable "public_subnet_ids" {
  description = "List of public subnet IDs to place NAT Gateways in"
  type        = list(string)
}

variable "eip_ids" {
  description = "List of Elastic IP allocation IDs for NAT Gateways"
  type        = list(string)

}

variable "igw_id" {
  description = "Internet Gateway ID (used to enforce dependency)"
  type        = string

}

variable "project" {
  description = "project-name"
  type        = string

}

variable "environment" {
  description = "Environment name (dev/int/prod)"
  type        = string

}

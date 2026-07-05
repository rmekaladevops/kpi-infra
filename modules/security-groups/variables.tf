variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string

}
variable "allowed_ssh_cidrs" {
  description = "List of CIDRs allowed to SSH into bastion"
  type        = list(string)

}

variable "app_port" {
  description = "Application port to allow within VPC"
  type        = number

}

variable "project" {
  description = "project-name"
  type        = string

}
variable "environment" {
  description = "Environment name (dev/int/prod)"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID to launch the bastion host in"
  type        = string

}
variable "bastion_sg_id" {
  description = "Security group ID for the bastion host"
  type        = string

}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string

}
variable "instance_type" {
  description = "EC2 instance type for bastion"
  default     = "t3.micro"
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

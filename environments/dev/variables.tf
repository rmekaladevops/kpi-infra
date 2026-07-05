variable "aws_region" {
  default = "ap-south-1"
}

variable "environment" {
  default = "dev"
}

variable "project_name" {
  default = "kpi"

}

variable "project" {
  default = "KPI"
  type    = string

}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}

variable "allowed_ssh_cidrs" { type = list(string) }
variable "app_port" {
  type    = number
  default = 8080

}
variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"

}

variable "deployer_principal_arns" {
  type    = list(string)
  default = []
}

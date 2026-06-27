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

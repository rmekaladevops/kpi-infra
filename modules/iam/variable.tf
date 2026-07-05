variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/int/prod)"
  type        = string
}

variable "deployer_principal_arns" {
  description = "List of ARNs allowed to assume the deployer role (e.g. GitHub Actions role)"
  type        = list(string)
  default     = []
}

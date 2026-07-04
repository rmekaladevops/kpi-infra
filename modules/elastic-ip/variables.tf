variable "eip_count" {
  description = "Number of Elastic IPs to create (usually matches number of NAT Gateways)"
  default     = 1
}

variable "project" {
  description = "project-name"
  type        = string

}

variable "environment" {
  description = "Environment name (dev/int/prod)"
  type        = string

}

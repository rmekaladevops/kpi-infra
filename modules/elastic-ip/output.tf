output "eip_ids" {
  description = "List of Elastic IP allocation IDs"
  value       = aws_eip.nat[*].id
}

output "eip_public_ips" {
  description = "List of Elastic IP public addresses"
  value       = aws_eip.nat[*].id

}

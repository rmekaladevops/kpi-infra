output "public_subnet_ids" {
  description = "List of public_subnet_ids"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet ids"
  value       = aws_subnet.private[*].id
}

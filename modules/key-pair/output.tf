output "key_name" {
  description = "The name of the key pair"
  value       = aws_key_pair.this.key_name
}

output "ssm_parameter_name" {
  description = "SSM parameter path where private key is stored"
  value       = aws_ssm_parameter.private_key.name
}

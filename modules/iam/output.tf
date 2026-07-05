output "ec2_instance_profile_name" {
  description = "EC2 instance profile name to attach to instances"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_role_arn" {
  description = "EC2 IAM role ARN"
  value       = aws_iam_role.ec2_role.arn
}

output "deployer_role_arn" {
  description = "Deployer IAM role ARN for CI/CD pipelines"
  value       = aws_iam_role.deployer_role.arn
}

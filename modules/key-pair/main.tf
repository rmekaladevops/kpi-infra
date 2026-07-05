# Generates an RSA key pair and stores private key in AWS SSM Parameter Store
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
resource "aws_key_pair" "this" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name = "${var.project}-${var.environment}-keypair"
  }
}

# Store private key securely in SSM (never in state files or git)
resource "aws_ssm_parameter" "private_key" {
  name        = "/${var.project}-${var.environment}/ec2/private-key"
  description = "Private key for ${var.project} ${var.environment} EC2 instances"
  type        = "SecureString"
  value       = tls_private_key.this.private_key_pem
  tags = {
    Name = "${var.project}-${var.environment}-private-key"
  }

}

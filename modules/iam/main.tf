# ── EC2 Instance Role ────────────────────────────────────────────
resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project}-${var.environment}-ec2-role"
  }
}

# ── Attach SSM Policy (allows Session Manager & parameter access) ─
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ── Custom Policy for SSM Parameter Store (read secrets) ─────────
resource "aws_iam_policy" "ssm_params" {
  name        = "${var.project}-${var.environment}-ssm-params-policy"
  description = "Allow EC2 to read project secrets from SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
      Resource = "arn:aws:ssm:*:*:parameter/${var.project}/${var.environment}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_params" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_params.arn
}

# ── Instance Profile (attaches role to EC2) ───────────────────────
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ── CI/CD Deployer Role (assumed by GitHub Actions / pipelines) ───
resource "aws_iam_role" "deployer_role" {
  name = "${var.project}-${var.environment}-deployer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = var.deployer_principal_arns }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project}-${var.environment}-deployer-role"
  }
}

resource "aws_iam_role_policy_attachment" "deployer_policy" {
  role       = aws_iam_role.deployer_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

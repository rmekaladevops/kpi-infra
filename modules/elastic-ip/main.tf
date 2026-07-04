resource "aws_eip" "nat" {
  count  = var.eip_count
  domain = "vpc"

  tags = {
    Name = "${var.project}-${var.environment}-eip-${count.index + 1}"
  }
}

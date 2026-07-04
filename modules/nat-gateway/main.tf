resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_ids)
  allocation_id = var.eip_ids[count.index]
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name = "${var.project}-${var.environment}-nat-gw-${count.index + 1}"
  }
  depends_on = [var.igw_id]
}

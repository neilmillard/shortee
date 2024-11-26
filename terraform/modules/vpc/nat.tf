resource "aws_nat_gateway" "nat" {
  depends_on    = [aws_internet_gateway.internet_gateway]
  count         = var.enable_nat_gateway ? local.public_subnet_count : 0
  allocation_id = aws_eip.outbound_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name       = "${var.name}-nat-${count.index}"
  }
}

resource "aws_route" "nat-route" {
  depends_on             = [aws_nat_gateway.nat]
  count                  = var.enable_nat_gateway ? local.public_subnet_count : 0
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  route_table_id         = aws_route_table.private_route_table[count.index].id
}

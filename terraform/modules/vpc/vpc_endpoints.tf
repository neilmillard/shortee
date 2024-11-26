resource "aws_vpc_endpoint" "gateway_endpoint" {
  count           = var.create_gateway_endpoints ? length(var.aws_gateway_endpoints) : 0
  vpc_id          = aws_vpc.vpc.id
  route_table_ids = aws_route_table.private_route_table.*.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.${element(var.aws_gateway_endpoints, count.index)}"
  tags            = var.tags
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  count               = var.create_interface_endpoints ? length(var.aws_interface_endpoints) : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${element(var.aws_interface_endpoints, count.index)}"
  subnet_ids          = aws_subnet.private_subnets.*.id
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  tags                = var.tags
  security_group_ids  = [aws_security_group.allow.id]
}

resource "aws_security_group" "allow" {
  name        = "${var.name}-allow-sg"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_ingress" {
  security_group_id = aws_security_group.allow.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_egress" {
  security_group_id = aws_security_group.allow.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_vpc_endpoint" "execute_api_vpc_endpoint" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.execute-api"
  subnet_ids          = aws_subnet.private_subnets.*.id
  tags                = merge(var.tags, tomap({ service_name = "com.amazonaws.${data.aws_region.current.name}.execute-api", resource_type = "interface_endpoint" }))
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = var.execute_api_private_dns_enabled
  security_group_ids  = [aws_security_group.allow.id]
}

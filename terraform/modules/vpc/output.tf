output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "intra_subnet_ids" {
  value = aws_subnet.intra_subnets.*.id
}

output "private_subnet_ids_map" {
  value = {
    for subnet in aws_subnet.private_subnets : subnet.availability_zone => subnet.id
  }
}

output "public_subnet_ids" {
  value = length(var.public_subnets) > 0 ? coalescelist(aws_subnet.public_subnets.*.id, []) : null
}

output "private_subnet_cidr_blocks" {
  value = aws_subnet.private_subnets.*.cidr_block
}

output "public_subnet_cidr_blocks" {
  value = length(var.public_subnets) > 0 ? coalescelist(aws_subnet.public_subnets.*.cidr_block, []) : null
}

output "security_group_ids" {
  value = aws_security_group.allow.id
}

output "outbound_eip_ids" {
  value = length(var.public_subnets) > 0 ? coalescelist(aws_eip.outbound_eip.*.id, []) : null
}

output "public_route_table_ids" {
  value = length(var.public_subnets) > 0 ? coalescelist(aws_route_table.public_route_table.*.id, []) : null
}

output "private_route_table_ids" {
  value = aws_route_table.private_route_table.*.id
}

output "intra_route_table_ids" {
  value = aws_route_table.intra_route_table.*.id
}

output "execute_api_vpc_endpoint_fqdn" {
  value = aws_vpc_endpoint.execute_api_vpc_endpoint.dns_entry[0].dns_name
}

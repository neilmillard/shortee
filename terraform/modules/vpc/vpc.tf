data "aws_availability_zones" "availability_zones" {}

data "aws_region" "current" {}

locals {
  private_subnet_count    = length(var.private_subnets) > 0 ? length(var.private_subnets) : length(data.aws_availability_zones.availability_zones.names)
  public_subnet_count     = length(var.public_subnets) > 0 ? length(var.public_subnets) : var.create_public_subnets ? length(data.aws_availability_zones.availability_zones.names) : 0
  intra_subnet_count      = length(var.intra_subnets) > 0 ? length(var.intra_subnets) : 0
  availability_zone       = length(var.azs) > 0 ? var.azs : data.aws_availability_zones.availability_zones.names
  public_route_table_ids  = aws_route_table.public_route_table.*.id
  private_route_table_ids = aws_route_table.private_route_table.*.id
  intra_route_table_ids   = aws_route_table.intra_route_table.*.id
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_vpc_dhcp_options" "vpc" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name         = "eu-west-2.compute.internal"
  tags                = var.tags
}

resource "aws_vpc_dhcp_options_association" "vpc" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc.id
}

resource "aws_internet_gateway" "internet_gateway" {
  count  = local.public_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = local.private_subnet_count
  availability_zone       = element(local.availability_zone, count.index)
  cidr_block              = length(var.private_subnets) > 0 ? var.private_subnets[count.index] : cidrsubnet(var.cidr_block, var.subnet_bits, count.index)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-private-${element(local.availability_zone, count.index)}"
  })
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = local.public_subnet_count > 0 ? local.public_subnet_count : 0
  availability_zone       = element(local.availability_zone, count.index)
  cidr_block              = length(var.public_subnets) > 0 ? var.public_subnets[count.index] : cidrsubnet(var.cidr_block, var.subnet_bits, count.index + var.subnet_step)
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${element(local.availability_zone, count.index)}"
  })
}

resource "aws_subnet" "intra_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = local.intra_subnet_count > 0 ? local.intra_subnet_count : 0
  availability_zone       = element(local.availability_zone, count.index)
  cidr_block              = length(var.intra_subnets) > 0 ? var.intra_subnets[count.index] : cidrsubnet(var.cidr_block, (var.subnet_bits + 1), count.index + var.subnet_step)
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-intra-${element(local.availability_zone, count.index)}"
  })
}


resource "aws_route_table" "public_route_table" {
  count  = local.public_subnet_count > 0 ? local.public_subnet_count : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = "${var.name}-pubrt-${count.index}"
  })
}

resource "aws_route" "route_all_public_subnet_traffic_to_igw" {
  count                  = local.public_subnet_count
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway[0].id
  route_table_id         = local.public_route_table_ids[count.index]
  depends_on             = [aws_route_table.public_route_table]
}

resource "aws_route_table_association" "public_route_table_associations" {
  count          = local.public_subnet_count
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.public_route_table.*.id, count.index)
}

resource "aws_route_table" "private_route_table" {
  count  = local.private_subnet_count
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = "${var.name}-privrt-${count.index}"
  })
}

resource "aws_route_table_association" "private_route_table_associations" {
  count          = local.private_subnet_count
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

resource "aws_eip" "outbound_eip" {
  count = local.public_subnet_count

  tags = merge(var.tags, {
    Name = "${var.name}-${data.aws_availability_zones.availability_zones.names[count.index]}"
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_route_table" "intra_route_table" {
  count  = local.intra_subnet_count
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = "${var.name}-intra-${count.index}"
  })
}

resource "aws_route_table_association" "intra_route_table_associations" {
  count          = local.intra_subnet_count
  subnet_id      = element(aws_subnet.intra_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.intra_route_table.*.id, count.index)
}

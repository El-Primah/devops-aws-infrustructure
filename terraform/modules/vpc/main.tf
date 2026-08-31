resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.vpc_tags
}


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  count  = var.enable_internet_gateway ? 1 : 0
  tags   = var.internet_gateway_tags
}


resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags              = lookup(each.value, "tags", {})

  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", false)
}


resource "aws_route_table" "this" {
  for_each = var.route_tables

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block           = route.value.cidr_block
      gateway_id           = lookup(route.value, "gateway_id", null)
      network_interface_id = lookup(route.value, "network_interface_id", null)
      nat_gateway_id       = lookup(route.value, "nat_gateway_id", null)
    }
  }
  tags = lookup(each.value, "tags", {})
}


# Route Table association
resource "aws_route_table_association" "this" {
  for_each = { for key, value in var.subnets : key => value if value.route_table_name != null }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.value.route_table_name].id
}



# NAT
resource "aws_eip" "nat" {
  for_each = var.eip

  domain = "vpc"
  tags   = lookup(each.value, "tags", {})
}

resource "aws_nat_gateway" "this" {
  for_each = var.nat

  allocation_id = lookup(each.value, "allocation_id", null)
  subnet_id     = lookup(each.value, "subnet_id", null)
  depends_on    = [aws_internet_gateway.this]
  tags          = lookup(each.value, "tags", {})
}



# Security Groups
resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.value.name        # this name of sg in aws cloud
  description = lookup(each.value, "description", "Managed by Terraform")
  vpc_id      = aws_vpc.this.id
  tags        = lookup(each.value, "tags", {})
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id = aws_security_group.this[each.value.security_group_name].id
  description       = lookup(each.value, "description", null)
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = lookup(each.value, "cidr_ipv4", null)
  cidr_ipv6         = lookup(each.value, "cidr_ipv6", null)
referenced_security_group_id = lookup(each.value, "referenced_security_group_id", null) != null ? aws_security_group.this[each.value.referenced_security_group_id].id : null
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  security_group_id  = aws_security_group.this[each.value.security_group_name].id
  description        = lookup(each.value, "description", null)
  from_port          = each.value.from_port
  to_port            = each.value.to_port
  ip_protocol        = each.value.ip_protocol
  cidr_ipv4          = lookup(each.value, "cidr_ipv4", null)
  cidr_ipv6          = lookup(each.value, "cidr_ipv6", null)
  referenced_security_group_id = lookup(each.value, "referenced_security_group_id", null) != null ? aws_security_group.this[each.value.referenced_security_group_id].id : null
}

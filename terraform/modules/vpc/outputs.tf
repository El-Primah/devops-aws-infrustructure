output "vpc_id" {
  value = aws_vpc.this.id
}

output "internet_gateway_id" {
  value = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "subnets" {
  value = aws_subnet.this
}

output "route_tables" {
  value = aws_route_table.this
}

output "nat_gateway" {
  value = aws_nat_gateway.this
}

output "eip" {
  value = aws_eip.nat
}

output "security_groups" {
  value = aws_security_group.this
}

output "ingress_rules" {
  value = aws_vpc_security_group_ingress_rule.this
}

output "egress_rules" {
  value = aws_vpc_security_group_egress_rule.this
}
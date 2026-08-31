variable "vpc_cidr_block" {
  description = "CIDR VPC"
  type        = string
}

variable "vpc_tags" {
  type    = map(string)
  default = null
}

variable "enable_internet_gateway" {
  type        = bool
  default     = false
}

variable "internet_gateway_tags" {
  type    = map(string)
  default = null
}

variable "enable_dns_support" {
  type        = bool
  default     = true # default terraform value for aws
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false # default terraform value for aws
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    route_table_name  = optional(string)
    tags              = optional(map(string))
    
    map_public_ip_on_launch = optional(bool)
  }))
  default = {}
}

variable "route_tables" {
  type = map(object({
    routes = list(object({
      cidr_block           = optional(string)
      gateway_id           = optional(string)
      network_interface_id = optional(string)
      nat_gateway_id       = optional(string)
    }))
    tags = optional(map(string))
  }))
  default = {}
}

variable "eip" {
  type = map(object({
    tags = optional(map(string))
  }))
  default = {}
}

variable "nat" {
  type = map(object({
    allocation_id        = optional(string)
    subnet_id            = optional(string)
    connectivity_type    = optional(string)
    tags                 = optional(map(string))
  }))
  default = {}
}

variable "security_groups" {
  type = map(object({
    name        = string
    description = optional(string)
    tags        = optional(map(string))
  }))
  default = {}
}

variable "ingress_rules" {
  type = list(object({
    security_group_name = string
    description         = optional(string)
    from_port           = optional(number)
    to_port             = optional(number)
    ip_protocol         = optional(string)
    cidr_ipv4           = optional(string)
    cidr_ipv6           = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    security_group_name  = string
    description          = optional(string)
    from_port            = optional(number)
    to_port              = optional(number)
    ip_protocol          = optional(string)
    cidr_ipv4            = optional(string)
    cidr_ipv6            = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = []
}

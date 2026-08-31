module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr_block          = "172.20.0.0/16"
  enable_internet_gateway = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  vpc_tags = {
    Name = "us-site-vpc"
  }
  
  internet_gateway_tags = {
    Name = "us-site-igw"
  }

  subnets = {
    "private1" = {
      cidr_block        = "172.20.128.0/20"
      availability_zone = "us-east-1a"
      route_table_name  = "private1"
      tags = {
        Name = "us-site-subnet-private1-us-east-1a"
      }
    },
    "private2" = {
      cidr_block        = "172.20.144.0/20"
      availability_zone = "us-east-1b"
      route_table_name  = "private2"
      tags = {
        Name = "us-site-subnet-private2-us-east-1b"
      }
    },
    "private3" = {
      cidr_block        = "172.20.160.0/20"
      availability_zone = "us-east-1a"
      route_table_name  = "private3"
      tags = {
        Name = "us-site-subnet-private3-us-east-1a"
      }
    },
    "private4" = {
      cidr_block        = "172.20.176.0/20"
      availability_zone = "us-east-1b"
      route_table_name  = "private4"
      tags = {
        Name = "us-site-subnet-private4-us-east-1b"
      }
    },
    "public1" = {
      cidr_block        = "172.20.0.0/20"
      availability_zone = "us-east-1a"
      route_table_name  = "public"
      tags = {
        Name = "us-site-subnet-public1-us-east-1a"
      }
    },
    "public2" = {
      cidr_block        = "172.20.16.0/20"
      availability_zone = "us-east-1b"
      route_table_name  = "public"
      tags = {
        Name = "us-site-subnet-public2-us-east-1b"
      }
    }
  }

  eip = {
    public1_eip = {
        tags = {Name = "us-site-eip-us-east-1a"
      }
    },
    public2_eip = {
        tags = {Name = "us-site-eip-us-east-1b"
      }
    }
  }
  
  nat = {
    public1_nat = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["public1"].id
      allocation_id     = module.vpc.eip["public1_eip"].id
	  tags = {
	    Name = "us-site-nat-public1-us-east-1a"
	  }
    },
    public2_nat = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["public2"].id
      allocation_id     = module.vpc.eip["public2_eip"].id
	  tags = {
	    Name = "us-site-nat-public2-us-east-1b"
	  }
    }
  }

  route_tables = {
    "private1" = {
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["public1_nat"].id
        }
      ]
      tags = {
	    Name = "us-site-rtb-private1-us-east-1a"
	  }
    },
    "private2" = {
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["public2_nat"].id
        }
      ]
      tags = {
	    Name = "us-site-rtb-private2-us-east-1b"
	  }
    },
    "private3" = {
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["public1_nat"].id
        }
      ]
      tags = {
	    Name = "us-site-rtb-private3-us-east-1a"
	  }
    },
    "private4" = {
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["public2_nat"].id
        }
      ]
      tags = {
	    Name = "us-site-rtb-private4-us-east-1b"
	  }
    },
    "public" = {
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = module.vpc.internet_gateway_id
        }
      ]
      tags = {
	    Name = "us-site-rtb-public"
	  }
    }
  }

  # --- SG ---
  security_groups = {
    "all_access" = {
      name        = "all-access"
      description = "all access"
      tags = {
        Name = "all-access"
      }
    }

    "vpn_sg" = {
      name        = "vpn-sg"
      description = "allow access to services via VPN"
      tags = {
        Name = "vpn-sg"
      }
    }
    
    "us_site_env_bastionhost_sg" = {
      name        = "us-site-env_bastionhost-sg"
      description = "Allow SSH from VPN"
      tags = {
        Name = "us-site-env_bastionhost-sg"
      }
    }
  }

  # --- Ingress Rules ---
  ingress_rules = [
    {
      security_group_name = "all_access" 
      cidr_ipv4           = "0.0.0.0/0"
      ip_protocol         = "-1"
    },
    {
      security_group_name = "all_access"
      cidr_ipv4           = "0.0.0.0/0"
      ip_protocol         = "icmp"
    },
    {
      security_group_name = "vpn_sg"
      from_port           = 80
      to_port             = 80
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.20/32"
    },
    {
      security_group_name = "vpn_sg"
      from_port           = 3
      to_port             = 4
      ip_protocol         = "icmp"
      cidr_ipv4           = "0.0.0.0/0"
    },
    {
      security_group_name = "vpn_sg"
      from_port           = 443
      to_port             = 443
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.20/32"
    },
    {
      security_group_name = "us_site_env_bastionhost_sg"
      description         = "SSH from Jenkins NAT gateway"
      from_port           = 22
      to_port             = 22
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.10/32"
    },
    {
      security_group_name = "us_site_env_bastionhost_sg"
      description         = "SSH from VPN"
      from_port           = 22
      to_port             = 22
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.20/32"
    }
  ]

  # --- Egress Rules ---
  egress_rules = [
    {
      security_group_name = "all_access"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
    },
    {
      security_group_name = "vpn_sg"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
    },
    {
      security_group_name = "us_site_env_bastionhost_sg"
      cidr_ipv4           = "0.0.0.0/0"
      ip_protocol         = "-1"
    },
    {
      security_group_name = "us_site_env_bastionhost_sg"
      cidr_ipv6           = "::/0"
      ip_protocol         = "-1"
    }
  ]
}

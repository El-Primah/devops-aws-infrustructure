module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block          = "172.21.32.0/20"
  enable_internet_gateway = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  vpc_tags = {
    Name = "dr-vpc"
  }
  
  internet_gateway_tags = {
    Name = "dr-igw"
  }

  subnets = {
    "private1" = {
      cidr_block        = "172.21.40.0/24"
      availability_zone = "eu-central-1a"
      route_table_name  = "private1"
      tags = {
        Name = "dr-subnet-private1-eu-central-1a"
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
    "private2" = {
      cidr_block        = "172.21.41.0/24"
      availability_zone = "eu-central-1b"
      route_table_name  = "private2"
      tags = {
        Name = "dr-subnet-private2-eu-central-1b"
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
    "public1" = {
      cidr_block        = "172.21.32.0/24"
      availability_zone = "eu-central-1a"
      route_table_name  = "public"
      tags = {
        Name = "dr-subnet-public1-eu-central-1a"
        "kubernetes.io/role/elb" = "1"
      }
    },
    "public2" = {
      cidr_block        = "172.21.33.0/24"
      availability_zone = "eu-central-1b"
      route_table_name  = "public"
      tags = {
        Name = "dr-subnet-public2-eu-central-1b"
        "kubernetes.io/role/elb" = "1"
      }
    }
  }

  eip = {
    public_eip = {
      tags = {
        Name = "disaster-recovery-nat-eip"
      }
    }
  }

  nat = {
    public_nat = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["public1"].id
      allocation_id     = module.vpc.eip["public_eip"].id
	  tags = {
	    Name = "dr-nat-gateway"
	  }
    }
  }

  route_tables = {
    "private1" = {
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["public_nat"].id
        }
      ]
      tags = {
	    Name = "dr-rtb-private1-eu-central-1a"
	  }
    },
    "private2" = {
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["public_nat"].id
        }
      ]
      tags = {
	    Name = "dr-rtb-private2-eu-central-1b"
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
	    Name = "dr-rtb-public"
	  }
    }
  }



  # --- SG ---
  security_groups = {
    "allow_all_internal" = {
      name        = "dr-allow-all-internal"
      description = "Allow all traffic within VPC"
      tags = {
        Name = "dr-allow-all-internal"
      }
    }

    "bastion" = {
      name        = "dr-bastionhost-sg"
      description = "Allow SSH from VPN"
      tags = {
        Name = "dr-bastionhost-sg"
      }
    }
    
    "lb_meme_gateway" = {
      name        = "lb-meme-gateway"
      description = "Allow 80 and 443 for 0.0.0.0/0"
      tags = {
        Name = "lb-meme-gateway"
      }
    }
  }

  # --- Ingress Rules ---
  ingress_rules = [
    {
      security_group_name = "allow_all_internal"
      description         = "Allow all inbound traffic from VPC CIDR"
      cidr_ipv4           = "172.21.32.0/20"
      ip_protocol         = "-1"
    },
    {
      security_group_name = "bastion"
      description         = "SSH from VPN"
      from_port           = 22
      to_port             = 22
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.20/32"
    },
    {
      security_group_name = "bastion"
      description         = "SSH from Jenkins NAT gateway"
      from_port           = 22
      to_port             = 22
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.10/32"
    },
    {
      security_group_name = "lb_meme_gateway"
      description         = "Allow inbound traffic to port 80"
      cidr_ipv4           = "0.0.0.0/0"
      from_port           = 80
      to_port             = 80
      ip_protocol         = "tcp"
    },
    {
      security_group_name = "lb_meme_gateway"
      description         = "Allow inbound traffic to port 443"
      cidr_ipv4           = "0.0.0.0/0"
      from_port           = 443
      to_port             = 443
      ip_protocol         = "tcp"
    }
  ]

  # --- Egress Rules ---
  egress_rules = [
    {
      security_group_name = "allow_all_internal"
      description         = "Allow all outbound traffic to VPC CIDR"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
    },
    {
      security_group_name = "bastion"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
      #cidr_ipv6           = "::/0"
    },
    {
      security_group_name = "lb_meme_gateway"
      description         = "Allow all outbound traffic to VPC CIDR"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
    }
  ]
}


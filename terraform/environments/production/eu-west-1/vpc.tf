module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr_block          = "172.24.0.0/16"
  enable_internet_gateway = true
  enable_dns_support      = true
  enable_dns_hostnames    = true

  vpc_tags = {
    Name        = "y_app"
    Terraform   = "true"
    Environment = "y_app"
  }
  
  internet_gateway_tags = {
    Name        = "y_app"
    Terraform   = "true"
    Environment = "y_app"
  }

  subnets = {
  # EU-WEST-1-A
    "utility_eu_west_1a" = {
      cidr_block        = "172.24.190.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "y_app_comp_com"
      tags = {
        Name                     = "utility-eu-west-1a.y_app.comp.com"
        SubnetType               = "Utility"
        AssociatedNatgateway     = "nat-0512aa3468a86f09c"
        KubernetesCluster        = "y_app.comp.com"
        "kubernetes.io/role/elb" = 1
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "y_app_public_eu_west_1a" = { # auto assign public ipv4
      cidr_block        = "172.24.101.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "y_app_public"
      
      map_public_ip_on_launch = true
      tags = {
        Name        = "y_app-public-eu-west-1a"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_elasticache_eu_west_1a" = {
      cidr_block        = "172.24.21.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "y_app_private_eu_west_1a"
      tags = {
        Name        = "y_app-elasticache-eu-west-1a"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_private_eu_west_1a" = {
      cidr_block        = "172.24.1.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "y_app_private_eu_west_1a"
      tags = {
        Name        = "y_app-private-eu-west-1a"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "eu_west_1a" = {
      cidr_block        = "172.24.148.0/22"
      availability_zone = "eu-west-1a"
      route_table_name  = "private_eu_west_1a_y_app_comp_com"
      tags = {
        Name                   = "eu-west-1a.y_app.comp.com"
        SubnetType             = "Private"
        KubernetesCluster      = "y_app.comp.com"
        "kubernetes.io/role/internal-elb" = 1
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "rds_pvt_subnet_1" = {
      cidr_block        = "172.24.0.128/25"
      availability_zone = "eu-west-1a"
      route_table_name  = "rds_pvt_rt" # RDS-Pvt-rt
      tags = {
        Name = "RDS-Pvt-subnet-1"
      }
    },
    "y_app_db_eu_west_1a" = {
      cidr_block        = "172.24.11.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "y_app_private_eu_west_1a"
      tags = {
        Name        = "y_app-db-eu-west-1a"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
  # EU-WEST-1-B
    "utility_eu_west_1b" = {
      cidr_block        = "172.24.191.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "y_app_comp_com"
      tags = {
        Name                   = "utility-eu-west-1b.y_app.comp.com"
        SubnetType             = "Utility"
        AssociatedNatgateway   = "nat-0b3f23729bc5bdf3d"
        KubernetesCluster      = "y_app.comp.com"
        "kubernetes.io/role/elb" = 1
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "y_app_public_eu_west_1b" = { # auto assign public ipv4
      cidr_block        = "172.24.102.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "y_app_public"
      
      map_public_ip_on_launch = true
      tags = {
        Name        = "y_app-public-eu-west-1b"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_private_eu_west_1b" = {
      cidr_block        = "172.24.2.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "y_app_private_eu_west_1b"
      tags = {
        Name        = "y_app-private-eu-west-1b"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_elasticache_eu_west_1b" = {
      cidr_block        = "172.24.22.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "y_app_private_eu_west_1b"
      tags = {
        Name        = "y_app-elasticache-eu-west-1b"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "eu_west_1b" = {
      cidr_block        = "172.24.160.0/22"
      availability_zone = "eu-west-1b"
      route_table_name  = "private_eu_west_1b_y_app_comp_com"
      tags = {
        Name                   = "eu-west-1b.y_app.comp.com"
        SubnetType             = "Private"
        KubernetesCluster      = "y_app.comp.com"
        "kubernetes.io/role/internal-elb" = 1
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "y_app_db_eu_west_1b" = {
      cidr_block        = "172.24.12.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "y_app_private_eu_west_1b"
      tags = {
        Name        = "y_app-db-eu-west-1b"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "rds_pvt_subnet_3" = {
      cidr_block        = "172.24.4.128/25"
      availability_zone = "eu-west-1b"
      route_table_name  = "rds_pvt_rt" # RDS-Pvt-rt
      tags = {
        Name = "RDS-Pvt-subnet-3"
      }
    },
  # EU-WEST-1-C
    "utility_eu_west_1c" = {
      cidr_block        = "172.24.192.0/24"
      availability_zone = "eu-west-1c"
      route_table_name  = "y_app_comp_com"
      tags = {
        Name                   = "utility-eu-west-1c.y_app.comp.com"
        SubnetType             = "Utility"
        AssociatedNatgateway   = "nat-01d96184300b54164"
        KubernetesCluster      = "y_app.comp.com"
        "kubernetes.io/role/elb" = 1
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "y_app_public_eu_west_1c" = { # auto assign public ipv4
      cidr_block        = "172.24.103.0/24"
      availability_zone = "eu-west-1c"
      route_table_name  = "y_app_public"
      
      map_public_ip_on_launch = true
      tags = {
        Name        = "y_app-public-eu-west-1c"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_private_eu_west_1c" = {
      cidr_block        = "172.24.3.0/24"
      availability_zone = "eu-west-1c"
      route_table_name  = "y_app_private_eu_west_1c"
      tags = {
        Name        = "y_app-private-eu-west-1c"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_elasticache_eu_west_1c" = {
      cidr_block        = "172.24.23.0/24"
      availability_zone = "eu-west-1c"
      route_table_name  = "y_app_private_eu_west_1c"
      tags = {
        Name        = "y_app-elasticache-eu-west-1c"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "eu_west_1c" = {
      cidr_block        = "172.24.168.0/22"
      availability_zone = "eu-west-1c"
      route_table_name  = "private_eu_west_1c_y_app_comp_com"
      tags = {
        Name                   = "eu-west-1c.y_app.comp.com"
        SubnetType             = "Private"
        KubernetesCluster      = "y_app.comp.com"
        "kubernetes.io/role/internal-elb" = 1
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "y_app_db_eu_west_1c" = {
      cidr_block        = "172.24.13.0/24"
      availability_zone = "eu-west-1c"
      route_table_name  = "y_app_private_eu_west_1c"
      tags = {
        Name        = "y_app-db-eu-west-1c"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "rds_pvt_subnet_2" = {
      cidr_block        = "172.24.4.0/25"
      availability_zone = "eu-west-1c"
      route_table_name  = "rds_pvt_rt" # RDS-Pvt-rt
      tags = {
        Name = "RDS-Pvt-subnet-2"
      }
    }
  }


  eip = {
    "y_app_eu_west_1a" = {
        tags = {
          Name        = "y_app-eu-west-1a"
          Terraform   = "true"
          Environment = "y_app"
        }
    },
    "eu_west_1a_y_app_comp_com" = {
        tags = {
          Name = "eu-west-1a.y_app.comp.com"
          KubernetesCluster = "y_app.comp.com"
          "kubernetes.io/cluster/y_app.comp.com" = "owned"
        }
    },
    "y_app_eu_west_1b" = {
        tags = {
          Name        = "y_app-eu-west-1b"
          Terraform   = "true"
          Environment = "y_app"
        }
    },
    "eu_west_1b_y_app_comp_com" = {
        tags = {
          Name = "eu-west-1b.y_app.comp.com"
          KubernetesCluster = "y_app.comp.com"
          "kubernetes.io/cluster/y_app.comp.com" = "owned"
        }
    },
    "y_app_eu_west_1c" = {
        tags = {
          Name        = "y_app-eu-west-1c"
          Terraform   = "true"
          Environment = "y_app"
        }
    },
    "eu_west_1c_y_app_comp_com" = {
        tags = {
          Name = "eu-west-1c.y_app.comp.com"
          KubernetesCluster = "y_app.comp.com"
          "kubernetes.io/cluster/y_app.comp.com" = "owned"
        }
    }
  }
  
  nat = {
    y_app_eu_west_1a = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["y_app_public_eu_west_1a"].id
      allocation_id     = module.vpc.eip["y_app_eu_west_1a"].id
      tags = {
        Name        = "y_app-eu-west-1a"
        Terraform   = "true"
        Environment = "y_app"
      }
    }
    
    eu_west_1a_y_app_comp_com = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["utility_eu_west_1a"].id
      allocation_id     = module.vpc.eip["eu_west_1a_y_app_comp_com"].id
      tags = {
        Name              = "eu-west-1a.y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    }
    
    y_app_eu_west_1b = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["y_app_public_eu_west_1b"].id
      allocation_id     = module.vpc.eip["y_app_eu_west_1b"].id
      tags = {
        Name        = "y_app-eu-west-1b"
        Terraform   = "true"
        Environment = "y_app"
      }
    }
    
    eu_west_1b_y_app_comp_com = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["utility_eu_west_1b"].id
      allocation_id     = module.vpc.eip["eu_west_1b_y_app_comp_com"].id
      tags = {
        Name              = "eu-west-1b.y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    }
    
    y_app_eu_west_1c = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["y_app_public_eu_west_1c"].id
      allocation_id     = module.vpc.eip["y_app_eu_west_1c"].id
      tags = {
        Name        = "y_app-eu-west-1c"
        Terraform   = "true"
        Environment = "y_app"
      }
    }
    
    eu_west_1c_y_app_comp_com = {
      type              = "gateway"
      connectivity_type = "public"
      subnet_id         = module.vpc.subnets["utility_eu_west_1c"].id
      allocation_id     = module.vpc.eip["eu_west_1c_y_app_comp_com"].id
      tags = {
        Name              = "eu-west-1c.y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    }
  }

  route_tables = {
    "y_app_public" = {
      routes = [{
          cidr_block = "0.0.0.0/0"
          gateway_id = module.vpc.internet_gateway_id
      }]
      tags = {
        Name        = "y_app-public"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_comp_com" = {
      routes = [{
          cidr_block = "0.0.0.0/0"
          gateway_id = module.vpc.internet_gateway_id
      }]
      tags = {
        Name              = "y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/kops/role"  = "public"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "y_app_private_eu_west_1a" = {
      routes = [{
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["y_app_eu_west_1a"].id
      }]
      tags = {
        Name        = "y_app-private-eu-west-1a"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_private_eu_west_1b" = {
      routes = [{
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["y_app_eu_west_1b"].id
      }]
      tags = {
        Name        = "y_app-private-eu-west-1b"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "y_app_private_eu_west_1c" = {
      routes = [{
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["y_app_eu_west_1c"].id
      }]
      tags = {
        Name        = "y_app-private-eu-west-1c"
        Terraform   = "true"
        Environment = "y_app"
      }
    },
    "rds_pvt_rt" = {
      routes = []
      tags = {
        Name = "RDS-Pvt-rt"
      }
    },
    "private_eu_west_1a_y_app_comp_com" = {
      routes = [{
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["eu_west_1a_y_app_comp_com"].id
      }]
      tags = {
        Name              = "private-eu-west-1a.y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/kops/role"  = "private-eu-west-1a"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "private_eu_west_1b_y_app_comp_com" = {
      routes = [{
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["eu_west_1b_y_app_comp_com"].id
      }]
      tags = {
        Name              = "private-eu-west-1b.y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/kops/role"  = "private-eu-west-1b"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    },
    "private_eu_west_1c_y_app_comp_com" = {
      routes = [{
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.vpc.nat_gateway["eu_west_1c_y_app_comp_com"].id
      }]
      tags = {
        Name              = "private-eu-west-1c.y_app.comp.com"
        KubernetesCluster = "y_app.comp.com"
        "kubernetes.io/kops/role"  = "private-eu-west-1c"
        "kubernetes.io/cluster/y_app.comp.com" = "owned"
      }
    }
  }

  # --- SG ---
  security_groups = {
    "vpn_sg" = {
      name        = "vpn-sg"
      description = "vpn-sg"
      tags = {}
    }
    
    "prodenv_bastionhost_sg" = {
      name        = "prodenv-bastionhost-sg"
      description = "Allow SSH from VPN"
      tags = {
        Name = "prodenv-bastionhost-sg"
      }
    }
      
    "eks_cluster_sg_comp_tf_production" = {
      name        = "eks-cluster-sg-comp-tf-production-975113496"
      description = "EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads."
      tags = {
        Name = "eks-cluster-sg-comp-tf-production-975113496"
        "kubernetes.io/cluster/comp-tf-production" = "owned"
      }
    }

    "comp_tf_production_cluster" = {
      name        = "comp-tf-production-cluster-20230806032225826400000004"
      description = "EKS cluster security group"
      tags = {
        Name = "comp-tf-production-cluster"
      }
    }
  
    "lambdaAll" = {
      name        = "lambdaAll"
      description = "For Production-Run-Platform-API-Command"
      tags = {}
    }
  }

  # --- Ingress Rules ---
  ingress_rules = [
    {
      security_group_name = "vpn_sg"
      description         = "VPN"
      from_port           = 80
      to_port             = 80
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.20/32"
    },
    {
      security_group_name = "vpn_sg"
      description         = "VPN"
      from_port           = 443
      to_port             = 443
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
      security_group_name = "prodenv_bastionhost_sg"
      description         = "SSH from Jenkins NAT gateway"
      from_port           = 22
      to_port             = 22
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.10/32"
    },
    {
      security_group_name = "prodenv_bastionhost_sg"
      description         = "SSH from VPN"
      from_port           = 22
      to_port             = 22
      ip_protocol         = "tcp"
      cidr_ipv4           = "257.10.10.20/32"
    },
    {
      security_group_name = "eks_cluster_sg_comp_tf_production"
      description         = "vpn"
      ip_protocol         = "-1"
      referenced_security_group_id = "vpn_sg"
    },
    {
      security_group_name = "eks_cluster_sg_comp_tf_production"
      ip_protocol         = "-1"
      referenced_security_group_id = "prodenv_bastionhost_sg"
    },
    {
      security_group_name = "comp_tf_production_cluster"
      description         = "VPC API Access"
      from_port           = 443
      to_port             = 443
      ip_protocol         = "tcp"
      cidr_ipv4           = "172.24.0.0/16"
    },
    {
      security_group_name = "lambdaAll"
      description         = ""
      cidr_ipv4           = "0.0.0.0/0"
      ip_protocol         = "-1"
    }
  ]

  # --- Egress Rules ---
  egress_rules = [
    {
      security_group_name = "vpn_sg"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
    },
    {
      security_group_name = "prodenv_bastionhost_sg"
      cidr_ipv4           = "0.0.0.0/0"
      ip_protocol         = "-1"
    },
    {
      security_group_name = "prodenv_bastionhost_sg"
      cidr_ipv6           = "::/0"
      ip_protocol         = "-1"
    },
    {
      security_group_name = "eks_cluster_sg_comp_tf_production"
      ip_protocol         = "-1"
      cidr_ipv4           = "0.0.0.0/0"
    },
    {
      security_group_name = "lambdaAll"
      description         = ""
      cidr_ipv4           = "0.0.0.0/0"
      ip_protocol         = "-1"
    }
  ]
}


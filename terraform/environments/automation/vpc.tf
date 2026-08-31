module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block          = "172.20.32.0/20"
  enable_internet_gateway = true
  enable_dns_support      = true
  enable_dns_hostnames    = true
  

  vpc_tags = {
    Name = "automation-vpc"
  }
  
  internet_gateway_tags = {
    Name = "automation-igw"
  }

  subnets = {
    "private1" = {
      cidr_block        = "172.20.40.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "private1"
      tags = {
        Name = "automation-subnet-private1-eu-west-1a"
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
    "private2" = {
      cidr_block        = "172.20.41.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "private2"
      tags = {
        Name = "automation-subnet-private2-eu-west-1b"
        "kubernetes.io/role/internal-elb" = "1"
      }
    },
    "public1" = {
      cidr_block        = "172.20.32.0/24"
      availability_zone = "eu-west-1a"
      route_table_name  = "public"
      tags = {
        Name = "automation-subnet-public1-eu-west-1a"
        "kubernetes.io/role/elb" = "1"
      }
    },
    "public2" = {
      cidr_block        = "172.20.33.0/24"
      availability_zone = "eu-west-1b"
      route_table_name  = "public"
      tags = {
        Name = "automation-subnet-public2-eu-west-1b"
        "kubernetes.io/role/elb" = "1"
      }
    }
  }

  route_tables = {
    "private1" = {
      routes = [
        {
          cidr_block           = "0.0.0.0/0"
          network_interface_id = "eni-09b8ef06d9b33a494"
        }
      ]
      tags = {
	    Name = "automation-rtb-private1-eu-west-1a"
	  }
    }
    "private2" = {
      routes = []
      tags = {
	    Name = "automation-rtb-private2-eu-west-1b"
	  }
    }
    "public" = {
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = module.vpc.internet_gateway_id
        }
      ]
      tags = {
	    Name = "automation-rtb-public"
	  }
    }
  }
}

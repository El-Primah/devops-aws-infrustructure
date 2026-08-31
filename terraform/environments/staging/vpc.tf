module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block          = "10.245.0.0/16"
  enable_internet_gateway = true
  enable_dns_support      = true
  enable_dns_hostnames    = true
  

  vpc_tags = {
    Environment = var.nonprod_environment
    Name = var.vpc_name_tag
    TerraformManaged = "true"
  }
  
  internet_gateway_tags = {
    "TerraformManaged" = "true"
  }

  subnets = {
    "private1" = {
      cidr_block        = "10.245.8.0/22"
      availability_zone = "eu-west-1a"
      route_table_name  = "private1"
      tags = {
	    "TerraformManaged"       = "true"
	    Name = "nonprod-private-subnet1"
	    "kubernetes.io/role/internal-elb" = "1"
      }
    },
    "private2" = {
      cidr_block        = "10.245.12.0/22"
      availability_zone = "eu-west-1b"
      route_table_name  = "private2"
      tags = {
	    "TerraformManaged"       = "true"
	    Name = "nonprod-private-subnet2"
	    "kubernetes.io/role/internal-elb" = "1"
      }
    },
    "public1" = {
      cidr_block        = "10.245.0.0/22"
      availability_zone = "eu-west-1a"
      route_table_name  = "public"
      tags = {
	    "TerraformManaged"       = "true"
	    Name = "nonprod-public-subnet1"
	    "kubernetes.io/role/elb" = "1"
      }
    },
    "public2" = {
      cidr_block        = "10.245.4.0/22"
      availability_zone = "eu-west-1b"
      route_table_name  = "public"
      tags = {
	    "TerraformManaged"       = "true"
	    Name = "nonprod-public-subnet2"
	    "kubernetes.io/role/elb" = "1"
      }
    },
    "public3" = {
      cidr_block        = "10.245.16.0/22"
      availability_zone = "eu-west-1a"
     # route_table_name  = "public"
      
      map_public_ip_on_launch = true
      
	  tags = {
	    Name = "nonprod-public-subnet3"
	    "kubernetes.io/role/elb" = "1"
	  }
    },
    "public4" = {
      cidr_block        = "10.245.20.0/22"
      availability_zone = "eu-west-1c"
     # route_table_name  = "public"
	  tags = {
	    Name = "nonprod-public-subnet4"
	    "kubernetes.io/role/elb" = "1"
	
	  }
    }
  }

  route_tables = {
    "private1" = {
      routes = [
        {
          cidr_block           = "0.0.0.0/0"
          network_interface_id = "eni-09c99326081698fe7"
        }
      ]
      tags = {
	    "TerraformManaged" = "true"
	  }
    }
    "private2" = {
      routes = []
      tags = {
	    "TerraformManaged" = "true"
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
	    "TerraformManaged" = "true"
	  }
    }
  }
}

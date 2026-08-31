module "eks" {
  source = "../../modules/k8s"

  cluster_name = var.eks_cluster_name
  cluster_version = var.eks_version
  authentication_mode = var.authentication_mode
  cluster_role_arn = aws_iam_role.comp_tf_stage_cluster.arn
  subnet_ids = [
    module.vpc.subnets["private1"].id,
    module.vpc.subnets["private2"].id,
  ]
  security_group_ids = [var.sg_for_eks]
  enabled_cluster_log_types = [ "api", "audit", "authenticator" ]
  tags = {
    "AWS.SSM.AppManager.EKS.Cluster.ARN" = "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/comp-tf-stage"
  }
  node_groups = {
    on_demand = {
      node_group_name = var.eks_node_group_on_demand_name
      node_role_arn   = aws_iam_role.on_demand_eks_node_group.arn
      subnet_ids = [
        module.vpc.subnets["private1"].id, 
        module.vpc.subnets["private2"].id 
      ]
      ami_type        = "AL2023_x86_64_STANDARD"
      capacity_type   = "ON_DEMAND"
      disk_size       = 0
      instance_types  = ["m5.2xlarge", "t3.2xlarge"]
      version         = var.eks_version
      labels          = {
        Environment   = "test"
        GithubOrg     = "terraform-aws-modules"
        GithubRepo    = "terraform-aws-eks"
      }
      tags            = {
        Name = var.eks_node_group_on_demand_name_tag
        environment = var.stage_environment
      }
      tags_all        = {}
      scaling = {
        desired_size = 3
        max_size     = 3
        min_size     = 3
      }
      update_config = {
        max_unavailable            = 1
        max_unavailable_percentage = 0
      }
      launch_template = {
        id      = module.external_comp_stage_eks_ex.launch_template_id
        version = "1"
      }
    }

    r52xlarge = {
      node_group_name = var.eks_node_group_r52xlarge_name
      subnet_ids = [
        module.vpc.subnets["private1"].id, 
        module.vpc.subnets["private2"].id 
      ]
      node_role_arn   = aws_iam_role.on_demand_eks_node_group.arn
      ami_type        = "AL2023_x86_64_STANDARD"
      capacity_type   = "ON_DEMAND"
      disk_size       = 0
      instance_types  = ["r5.2xlarge"]
      version         = var.eks_version
      tags            = {}
      tags_all        = {}
      update_config = {
        max_unavailable            = 1
        max_unavailable_percentage = 0
      }
      scaling = {
        desired_size = 1
        max_size     = 1
        min_size     = 1
      }
      labels = {}
      launch_template = {
        id      = module.external_comp_stage_eks_ex.launch_template_id
        version = "1"
      }
    }
  }

  vpc_cni_addon_config = {
    addon_version = "v1.19.2-eksbuild.1"
  }

  kube_proxy_addon_config = {
    addon_version = "v1.32.0-eksbuild.2"
  }
}

# Other Add-ons
resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.46.0-eksbuild.1" 
  depends_on    = [module.eks]
}

#resource "aws_eks_addon" "coredns" {
#  cluster_name  = module.eks.cluster_name
#  addon_name    = "coredns"
#  addon_version = "v1.11.4-eksbuild.2"
#  depends_on    = [module.eks]
#}

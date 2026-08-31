module "eks" {
  source = "../../modules/k8s"

  cluster_name             = var.eks_cluster_name
  cluster_version          = var.eks_version
  authentication_mode      = "API_AND_CONFIG_MAP"
  cluster_role_arn         = aws_iam_role.eks_cluster_role.arn
  subnet_ids = [
        module.vpc.subnets["private1"].id,
        module.vpc.subnets["private2"].id
  ]
  security_group_ids        = [
    module.vpc.security_groups["allow_all_internal"].id,
    module.vpc.security_groups["lb_meme_gateway"].id
  ]
  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  node_groups = {
    default = {
      node_group_name = var.eks_default_node_group_name
      node_role_arn   = aws_iam_role.eks_node_role.arn
      subnet_ids = [
            module.vpc.subnets["private1"].id,
            module.vpc.subnets["private2"].id
      ]
      ami_type        = "AL2023_x86_64_STANDARD"
      capacity_type   = "ON_DEMAND"
      instance_types  = ["m5.2xlarge", "m6i.2xlarge", "m5a.2xlarge", "m4.2xlarge"]
      disk_size       = 0
      version         = var.eks_version
      
      scaling = {
        desired_size = 5
        max_size     = 5
        min_size     = 5
      }

      update_config = {
        max_unavailable = 1
        max_unavailable_percentage = 0
      }

      tags     = {}
      tags_all = {}
      labels   = {}
      launch_template = {
        id      = aws_launch_template.eks_node_group_launch_template.id
        version = aws_launch_template.eks_node_group_launch_template.latest_version
      }
    }
  }

  vpc_cni_addon_config = {
    addon_version = "v1.20.4-eksbuild.1"
  }

  kube_proxy_addon_config = {
    addon_version = "v1.32.6-eksbuild.12"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"
  addon_version = "v1.11.4-eksbuild.2"
  depends_on    = [module.eks]
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.51.1-eksbuild.1" 
  depends_on    = [module.eks]
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "metrics-server"
  depends_on    = [module.eks]
}


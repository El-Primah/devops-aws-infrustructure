module "eks" {
  source = "../../modules/k8s"

  cluster_name = var.eks_cluster_name
  cluster_version = var.eks_version
  authentication_mode = "CONFIG_MAP"
  cluster_role_arn = aws_iam_role.face2gen_automation_dev_cluster.arn
  subnet_ids = [
    module.vpc.subnets["private1"].id, 
    module.vpc.subnets["private2"].id
  ]
  security_group_ids = ["sg-05585e8ae8f51ff7d"]
  enabled_cluster_log_types = [ "api", "audit", "authenticator" ]
  node_groups = {
    encrypted = {
      node_group_name = var.eks_node_group_name_encrypted
      subnet_ids = [
        module.vpc.subnets["private1"].id, 
        module.vpc.subnets["private2"].id 
      ]
      node_role_arn   = aws_iam_role.on_demand_eks_node_group.arn
      ami_type        = "AL2023_x86_64_STANDARD"
      capacity_type   = "ON_DEMAND"
      disk_size       = 0
      instance_types  = ["m5.2xlarge", "m6i.2xlarge", "m5a.2xlarge", "m4.2xlarge"]
      version         = var.eks_version
      tags            = {}
      tags_all        = {}
      update_config = {
        max_unavailable            = 1
        max_unavailable_percentage = 0
      }
      scaling = {
        desired_size = 0
        max_size     = 1
        min_size     = 0
      }
      labels = {
        "nvidia.com/gpu.deploy.driver" = "false"
      }
      launch_template = {
        id      = module.external_comp_eks_ex.launch_template_id
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
  addon_version = "v1.32.0-eksbuild.1" 
  depends_on    = [module.eks]
}

#resource "aws_eks_addon" "coredns" {
#  cluster_name  = module.eks.cluster_name
#  addon_name    = "coredns"
#  addon_version = "v1.11.4-eksbuild.2"
#  depends_on    = [module.eks]
#}

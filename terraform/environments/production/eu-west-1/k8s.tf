module "eks" {
  source = "../../../modules/k8s"

  cluster_name        = var.eks_cluster_name
  cluster_version     = var.eks_version
  authentication_mode = "CONFIG_MAP"
  cluster_role_arn    = aws_iam_role.eks_cluster_role.arn
  subnet_ids = [
    module.vpc.subnets["eu_west_1a"].id,
    module.vpc.subnets["eu_west_1c"].id
  ]
  security_group_ids = [
    module.vpc.security_groups["comp_tf_production_cluster"].id,
  ]
  enabled_cluster_log_types = [ "api", "audit", "authenticator" ]
  
  node_groups = {}
}

# NodeGroup
resource "aws_eks_node_group" "default" {
  cluster_name    = module.eks.cluster_name
  node_group_name = var.eks_default_node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    module.vpc.subnets["eu_west_1a"].id,
    module.vpc.subnets["eu_west_1c"].id
  ]
  ami_type        = "AL2023_x86_64_STANDARD"
  capacity_type   = "ON_DEMAND"
  # disk_size       = 200
  instance_types  = ["m5.2xlarge", "m6i.2xlarge", "m5a.2xlarge", "m4.2xlarge"]
  # version         = var.eks_version

  scaling_config {
    desired_size = 6
    max_size     = 6
    min_size     = 6
  }

  update_config {
    max_unavailable = 1
  }

  node_repair_config {
    enabled = true
  }

  launch_template {
#    id      = module.eks_node_group_launch_template.launch_template_id
#    version = module.eks_node_group_launch_template.launch_template_latest_version
    id      = "lt-047ecb09a97949eb0" 
    version = 3
  }

	labels = {
		Environment   = "production"
		GithubOrg     = "terraform-aws-modules"
		GithubRepo    = "terraform-aws-eks"
	}
	tags = {
		Name        = "on-demand"
		environment = var.environment
	}

  #depends_on = [
  #  aws_eks_addon.vpc_cni
  #]
  lifecycle {
   ignore_changes = all
  }
}


# Addons
resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  depends_on   = [
    module.eks,
    aws_eks_node_group.default
  ]
}


# --- not need yet ---
#resource "aws_eks_addon" "vpc_cni" {
#  cluster_name  = module.eks.cluster_name
#  addon_name    = "vpc-cni"
#  depends_on    = [module.eks]
#}

#resource "aws_eks_addon" "coredns" {
#  cluster_name = module.eks.cluster_name
#  addon_name   = "coredns"
#  depends_on   = [
#    module.eks,
#    aws_eks_node_group.default
#  ]
#}

#resource "aws_eks_addon" "kube_proxy" {
#  cluster_name = module.eks.cluster_name
#  addon_name   = "kube-proxy"
#  depends_on   = [module.eks]
#}

#resource "aws_eks_addon" "metrics_server" {
#  cluster_name  = module.eks.cluster_name
#  addon_name    = "metrics-server"
#  depends_on    = [module.eks]
#}

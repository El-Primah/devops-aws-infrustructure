resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn
  bootstrap_self_managed_addons = false

  enabled_cluster_log_types = var.enabled_cluster_log_types

  access_config {
    authentication_mode = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }
  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.value.node_group_name
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnet_ids

  ami_type        = each.value.ami_type
  capacity_type   = each.value.capacity_type
  disk_size       = each.value.disk_size
  instance_types  = each.value.instance_types
  labels          = each.value.labels
  version         = each.value.version
  tags            = each.value.tags
  tags_all        = each.value.tags_all

  scaling_config {
    desired_size = each.value.scaling.desired_size
    max_size     = each.value.scaling.max_size
    min_size     = each.value.scaling.min_size
  }

  update_config {
    max_unavailable            = each.value.update_config.max_unavailable
  }

  dynamic "launch_template" {
  for_each = try(each.value.launch_template.id, "") != "" && try(each.value.launch_template.version, "") != "" ? [1] : []
    content {
      id      = each.value.launch_template.id
      version = each.value.launch_template.version
    }
  }

  depends_on = [aws_eks_addon.vpc_cni]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name         = aws_eks_cluster.this.name
  addon_name           = "vpc-cni"
  addon_version        = var.vpc_cni_addon_config != null ? var.vpc_cni_addon_config.addon_version : null
  configuration_values = var.vpc_cni_addon_config != null ? var.vpc_cni_addon_config.configuration_values : null
  preserve             = var.vpc_cni_addon_config != null ? var.vpc_cni_addon_config.preserve : false

  resolve_conflicts_on_create = var.vpc_cni_addon_config != null ? var.vpc_cni_addon_config.resolve_conflicts_on_create : "NONE"
  resolve_conflicts_on_update = var.vpc_cni_addon_config != null ? var.vpc_cni_addon_config.resolve_conflicts_on_update : "NONE"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name         = aws_eks_cluster.this.name
  addon_name           = "kube-proxy"
  addon_version        = var.kube_proxy_addon_config != null ? var.kube_proxy_addon_config.addon_version : null
  configuration_values = var.kube_proxy_addon_config != null ? var.kube_proxy_addon_config.configuration_values : null
  preserve             = var.kube_proxy_addon_config != null ? var.kube_proxy_addon_config.preserve : false

  resolve_conflicts_on_create = var.kube_proxy_addon_config != null ? var.kube_proxy_addon_config.resolve_conflicts_on_create : "NONE"
  resolve_conflicts_on_update = var.kube_proxy_addon_config != null ? var.kube_proxy_addon_config.resolve_conflicts_on_update : "NONE"

  depends_on = [aws_eks_cluster.this]
}


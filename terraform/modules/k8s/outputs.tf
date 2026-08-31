output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_id" {
  description = "EKS Cluster ID (Name)"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS Cluster API server endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluster CA certificate data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "cluster_version" {
  description = "EKS Kubernetes version"
  value       = aws_eks_cluster.this.version
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_group_asg_names" {
  description = "Map of EKS Node Group names to their respective Auto Scaling Group names."
  value = {
    for k, ng in aws_eks_node_group.this : k => ng.resources[0].autoscaling_groups[0].name
  }
}

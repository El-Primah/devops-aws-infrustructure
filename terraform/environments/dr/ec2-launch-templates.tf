resource "aws_launch_template" "eks_node_group_launch_template" {
  name = var.eks_node_group_launch_template

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_size           = 200
      volume_type           = "gp3"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  tags = {
    "eks:cluster-name"   = var.eks_cluster_name,
    "eks:nodegroup-name" = var.eks_default_node_group_name
  }
}

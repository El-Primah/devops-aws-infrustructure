resource "aws_launch_template" "this" {
  name        = var.name
  description = var.description

  tags     = var.tags
  tags_all = var.tags_all

  block_device_mappings {
    device_name = var.device_name
    ebs {
      delete_on_termination = var.delete_on_termination
      iops                  = var.ebs_iops
      volume_size           = var.ebs_volume_size
      volume_type           = var.ebs_volume_type
      encrypted             = var.encrypted != "" ? var.encrypted : null
      kms_key_id            = var.kms_key_id != "" ? var.kms_key_id : null
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }
  
  lifecycle {
    ignore_changes = [
      block_device_mappings.0.ebs.0.kms_key_id
    ]
  }

  dynamic "tag_specifications" {
    for_each = var.tag_specifications
    content {
      resource_type = tag_specifications.value.resource_type
      tags          = tag_specifications.value.tags
    }
  }
}



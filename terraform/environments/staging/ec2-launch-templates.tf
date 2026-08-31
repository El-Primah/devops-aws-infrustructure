module "external_comp_stage_eks_ex" {
  source = "../../modules/ec2_launch_templates"
  description = ""
  name        = "comp-stage-eks"

  tags = {
    environment = var.stage_environment
  }

  tags_all = {
    environment = var.stage_environment
  }
  encrypted = "true"
  kms_key_id = "arn:aws:kms:eu-west-1:${var.aws_account_id}:key/60ab2221-fd3b-405b-bc17-c5b2ff0a2776"

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name = "eks-comp-tf-stage-on-demand"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "eks-comp-tf-stage-on-demand"
      }
    }
  ]
}

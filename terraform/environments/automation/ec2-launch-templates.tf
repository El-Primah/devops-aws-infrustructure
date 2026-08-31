module "external_comp_eks_ex" {
  source = "../../modules/ec2_launch_templates"

  name        = var.external_comp_eks_ex_name
  description = "EKS managed node group external launch template"

  tags = {
    environment = "non-prod"
  }

  tags_all = {
    environment = "non-prod"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name = "eks-comp-nonprod-tf-stage-on-demand"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "eks-comp-nonprod-tf-stage-on-demand"
      }
    }
  ]
}

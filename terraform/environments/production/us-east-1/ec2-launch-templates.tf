module "external_comp_eks_ex" {
  source = "../../../modules/ec2_launch_templates"

  name        = "eks-comp-us-site-tf-on-demand"
  description = "" # EKS managed node group external launch template
  encrypted   = true
  kms_key_id  = "arn:aws:kms:us-east-1:939393939393:key/1a0dcd92-7b8b-4714-80d2-70e379f5141c"

  tags = {
    environment = "us-site"
  }

  tags_all = {
    environment = "us-site"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name = "eks-comp-us-site-tf-on-demand"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "eks-comp-us-site-tf-on-demand"
      }
    }
  ]
}

resource "aws_instance" "bastion" {
  ami           = "ami-004e960cde33f9146"
  instance_type = "t3.micro"

  subnet_id              = module.vpc.subnets["public1"].id
  vpc_security_group_ids = [module.vpc.security_groups["bastion"].id]
  iam_instance_profile   = aws_iam_instance_profile.bastion_eks_access_profile.name
  key_name               = "dr-opsmaster"

  associate_public_ip_address = true

  root_block_device {
    volume_size   = 20
  }
  tags = {
    Name = var.eks_bastion_instance
  }

  user_data = templatefile("${path.module}/templates/bastion_userdata_new.tftpl", {
    cluster_version   = "1.32"
 })

  depends_on = [
    aws_eks_access_entry.bastion_entry,
    module.eks
  ]
}

resource "aws_eks_access_entry" "bastion_entry" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.bastion_eks_access_role.arn
  type = "STANDARD"
  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "bastion_admin_access" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.bastion_entry.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.bastion_entry]
}

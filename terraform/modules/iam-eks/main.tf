
# ----- EKS role -----
resource "aws_iam_role" "cluster" {
  name = var.cluster_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action = "sts:AssumeRole",
      Sid = "EKSClusterAssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "cluster_deny_logs" {
  name = var.cluster_deny_logs_policy_name
  role = aws_iam_role.cluster.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Deny",
      Action = ["logs:CreateLogGroup"],
      Resource = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/eks/${var.cluster_name}/cluster"
    }]
  })
}

# ----- Node group EKS role -----

resource "aws_iam_role" "node_group" {
  name        = var.node_group_role_name
  description = var.node_group_role_description
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole",
      Sid = "EKSNodeAssumeRole"
    }]
  })
  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  count      = var.attach_worker_node_policy ? 1 : 0
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  count      = var.attach_cni_policy ? 1 : 0
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.attach_ecr_readonly_policy ? 1 : 0
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# SSM - can be diff for environments
resource "aws_iam_role_policy_attachment" "node_group_ssm_policy" {
  count      = var.attach_ssm_managed_instance_core ? 1 : 0
  role       = aws_iam_role.node_group.name
  policy_arn = var.ssm_policy_arn
}


# ----- Node group Pilicies -----
# CloudWatch Logs
resource "aws_iam_role_policy" "node_group_cloudwatch_logs" {
  count = var.create_cloudwatch_logs_policy ? 1 : 0
  name  = var.cloudwatch_logs_policy_name
  role  = aws_iam_role.node_group.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

# EBS CSI Driver (Customer Managed Policy) 
resource "aws_iam_policy" "ebs_csi_driver" {
  count       = var.create_ebs_csi_driver_policy ? 1 : 0
  name        = var.ebs_csi_driver_policy_name
  description = "Policy for Kubernetes ebs-csi-driver to manage EBS volumes"
  policy      = var.ebs_csi_driver_policy_document
}
resource "aws_iam_role_policy_attachment" "node_group_ebs_csi_driver" {
  count      = var.create_ebs_csi_driver_policy ? 1 : 0
  role       = aws_iam_role.node_group.name
  policy_arn = aws_iam_policy.ebs_csi_driver[0].arn
}


# additional iniline nodegroup role policies

resource "aws_iam_role_policy" "node_group_additional_inline" {
  for_each = var.node_group_additional_inline_policies
  name     = each.key
  role     = aws_iam_role.node_group.name
  policy   = each.value
}


# Attach outer policies to Node group role

resource "aws_iam_role_policy_attachment" "node_group_additional_managed" {
  for_each   = var.node_group_additional_managed_policies
  role       = aws_iam_role.node_group.name
  policy_arn = each.value
}


# Bastion

resource "aws_iam_role" "bastion_eks_access" {
  count = var.create_bastion_role ? 1 : 0
  name  = var.bastion_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole",
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "bastion_eks_access_eks_ro" {
  count = var.create_bastion_role ? 1 : 0
  name  = var.bastion_policy_name
  role  = aws_iam_role.bastion_eks_access[0].name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "eks:DescribeCluster",
        "eks:AccessKubernetesApi"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_additional_managed" {
  for_each   = var.bastion_additional_managed_policies
  role       = aws_iam_role.bastion_eks_access[0].name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "bastion_eks_access_profile" {
  count = var.create_bastion_role ? 1 : 0
  name  = var.bastion_instance_profile_name
  role  = aws_iam_role.bastion_eks_access[0].name
}

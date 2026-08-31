# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action = "sts:AssumeRole",
      Sid = "EKSClusterAssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "deny_logs_cluster" {
  name = var.deny_logs_cluster_name
  role = aws_iam_role.eks_cluster_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Deny",
      Action = ["logs:CreateLogGroup"],
      Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/f_item-dr/cluster"
    }]
  })
}

# EKS Node Group Role
resource "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name
  description = "EKS node group role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole",
      Sid = "EKSNodeAssumeRole"
    }]
  })

  tags = {
    environment = "dr"
  }
}

# Node Group Policy Attachments
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "rekognition" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
}

resource "aws_iam_role_policy_attachment" "eks_worker" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Inline Node Policies
resource "aws_iam_role_policy" "admin_update_user" {
  name = var.admin_update_user_name
  role = aws_iam_role.eks_node_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "cognito-idp:AdminUpdateUserAttributes",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "cloudwatch_rw" {
  name = var.cloudwatch_rw_name
  role = aws_iam_role.eks_node_role.name
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

resource "aws_iam_role_policy" "phone_validate" {
  name = var.phone_validate_name
  role = aws_iam_role.eks_node_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["mobiletargeting:PhoneNumberValidate"],
      Resource = "*"
    }]
  })
}

# role for bastion instead of AmazonSSMRoleForInstancesQuickSetup
resource "aws_iam_role" "bastion_eks_access_role" {
  name = var.bastion_eks_access_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole",
    }]
  })
}

resource "aws_iam_role_policy" "eks_ro" {
  name = var.eks_ro
  role = aws_iam_role.bastion_eks_access_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:AccessKubernetesApi"
      ],
      "Resource": "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.bastion_eks_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_patch_assosiation" {
  role       = aws_iam_role.bastion_eks_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}

# iam profile for bastion with role bastion_eks_access
resource "aws_iam_instance_profile" "bastion_eks_access_profile" {
  name = var.bastion_eks_access_profile
  role = aws_iam_role.bastion_eks_access_role.name
}

# Custom Policy for S3
resource "aws_iam_policy" "s3_access_dr" {
  name        = var.eks_access_to_s3

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListObjects"]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::${var.dr_bucket_name}/*"]
      },
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::${var.dr_bucket_name}"]
      },
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::comp-user-bl_item-dr",
          "arn:aws:s3:::comp-user-bl_item-dr/*"
        ]
      },
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::comp-resources-dump-ireland/*"]
      },
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::comp-resources-dump-ireland"]
      },
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::datasets-for-crop-job",
          "arn:aws:s3:::datasets-for-crop-job/*"
        ]
      },
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::gestalt-match",
          "arn:aws:s3:::gestalt-match/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.s3_access_dr.arn
}

# CSI EBS Driver Policy
resource "aws_iam_policy" "ebs_csi_driver_dr" {
  name = var.ebs_csi_driver_policy
  description = "Policy for Kubernetes ebs-csi-driver to manage EBS volumes"
  policy = jsonencode(
    {
        "Statement": [
            {
                "Action": [
                    "ec2:CreateSnapshot",
                    "ec2:AttachVolume",
                    "ec2:DetachVolume",
                    "ec2:ModifyVolume",
                    "ec2:DescribeAvailabilityZones",
                    "ec2:DescribeInstances",
                    "ec2:DescribeSnapshots",
                    "ec2:DescribeTags",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeVolumesModifications"
                ],
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:CreateTags"
                ],
                "Condition": {
                    "StringEquals": {
                        "ec2:CreateAction": [
                            "CreateVolume",
                            "CreateSnapshot"
                        ]
                    }
                },
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:ec2:*:*:volume/*",
                    "arn:aws:ec2:*:*:snapshot/*"
                ]
            },
            {
                "Action": [
                    "ec2:DeleteTags"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:ec2:*:*:volume/*",
                    "arn:aws:ec2:*:*:snapshot/*"
                ]
            },
            {
                "Action": [
                    "ec2:CreateVolume"
                ],
                "Condition": {
                    "StringLike": {
                        "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:CreateVolume"
                ],
                "Condition": {
                    "StringLike": {
                        "aws:RequestTag/CSIVolumeName": "*"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:CreateVolume"
                ],
                "Condition": {
                    "StringLike": {
                        "aws:RequestTag/kubernetes.io/cluster/*": "owned"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:DeleteVolume"
                ],
                "Condition": {
                    "StringLike": {
                        "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:DeleteVolume"
                ],
                "Condition": {
                    "StringLike": {
                        "ec2:ResourceTag/CSIVolumeName": "*"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:DeleteVolume"
                ],
                "Condition": {
                    "StringLike": {
                        "ec2:ResourceTag/kubernetes.io/cluster/*": "owned"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:DeleteSnapshot"
                ],
                "Condition": {
                    "StringLike": {
                        "ec2:ResourceTag/CSIVolumeSnapshotName": "*"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": [
                    "ec2:DeleteSnapshot"
                ],
                "Condition": {
                    "StringLike": {
                        "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
                    }
                },
                "Effect": "Allow",
                "Resource": "*"
            }
        ],
        "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.ebs_csi_driver_dr.arn
}



# IAM role for Consumer Cognito
resource "aws_iam_role" "congito_sms_role" {
  name = var.congito_sms_role
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = ""
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.cognito_sms_external_id
          }
        }
      }
    ]
  })
}

# IAM policy for Consumer Cognito Role
resource "aws_iam_policy" "policy_cognito_1616161616161_for_congito_sms_role" {
  name = var.policy_cognito_1616161616161_for_congito_sms_role
  path = "/service-role/"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:publish"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attachment_cognito_1616161616161_to_congito_sms_role" {
  role       = aws_iam_role.congito_sms_role.name
  policy_arn = aws_iam_policy.policy_cognito_1616161616161_for_congito_sms_role.arn
}

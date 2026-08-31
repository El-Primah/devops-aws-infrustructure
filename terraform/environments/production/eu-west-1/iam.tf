resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
          Sid = "EKSClusterAssumeRole"
        },
      ]
      Version   = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  role = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "eks_cluster_role_policy_log_group_name" {
  name = var.eks_cluster_role_policy_log_group_name
  role = aws_iam_role.eks_cluster_role.name
  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup"
          ],
          "Effect": "Deny",
          "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/eks/${var.eks_cluster_name}/cluster"
        }
      ],
      "Version": "2012-10-17"
    }
  )
}



# EKS Node Group Role
resource "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name
  description = "EKS managed node group IAM role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole",
      Sid = "EKSNodeAssumeRole"
    }]
  })

  tags = {
    environment = var.environment
  }
}

# Inline eks node role Policies
resource "aws_iam_role_policy" "admin_update_user" {
  name = var.admin_update_user_name
  role = aws_iam_role.eks_node_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid = "VisualEditor0",
      Effect = "Allow",
      Action = "cognito-idp:AdminUpdateUserAttributes",
      Resource = "arn:aws:cognito-idp:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:userpool/eu-west-1_QN45ctMHx"
    }]
  })
}

resource "aws_iam_role_policy" "kms_decrypt" {
  name = var.kms_decrypt_name
  role = aws_iam_role.eks_node_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "kms:Decrypt",
      Sid      = "AllowDecryptData",
      Resource = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
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

# eks node role AWS managed Policy Attachments
resource "aws_iam_role_policy_attachment" "ec2_for_ssm" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "rekognition_full_access" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_worker" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_instance_core" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_ec2_default" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

# eks node role Customer mnaged Policy Attachments
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.s3_access_prod.arn
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
}

# Customer managed policies
resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name = var.ebs_csi_driver_policy_name
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

resource "aws_iam_policy" "s3_access_prod" {
  name        = var.s3_access_prod_name
  description = "Policy for exeternal s3 bucket access"
  policy = jsonencode(
  {
      "Statement": [
          {
              "Action": [
                  "s3:GetObject",
                  "s3:ListObjects"
              ],
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-production-config/*"
              ]
          },
          {
              "Action": [
                  "mobiletargeting:PhoneNumberValidate"
              ],
              "Effect": "Allow",
              "Resource": [
                  "*"
              ]
          },
          {
              "Action": [
                  "cognito-idp:AdminGetUser"
              ],
              "Effect": "Allow",
              "Resource": [
                  "*"
              ]
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-abc-public",
                  "arn:aws:s3:::comp-abc-public/*"
              ]
          },
          {
              "Action": [
                  "s3:ListBucket"
              ],
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-production-config"
              ]
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-user-bl_item-production",
                  "arn:aws:s3:::comp-user-bl_item-production/*"
              ]
          },
          {
              "Action": [
                  "s3:GetObject",
                  "s3:PutObject"
              ],
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-resources-dump-ireland/*"
              ]
          },
          {
              "Action": [
                  "s3:ListBucket"
              ],
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-resources-dump-ireland"
              ]
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::datasets-for-crop-job",
                  "arn:aws:s3:::datasets-for-crop-job/*"
              ]
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::gestalt-match",
                  "arn:aws:s3:::gestalt-match/*"
              ]
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-eu-us-migrations",
                  "arn:aws:s3:::comp-eu-us-migrations/*"
              ]
          },
          {
              "Action": "s3:*",
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:s3:::comp-genomic-documents-eu",
                  "arn:aws:s3:::comp-genomic-documents-eu/*"
              ]
          }
      ],
      "Version": "2012-10-17"
  }
 )
}

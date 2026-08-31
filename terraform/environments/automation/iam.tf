resource "aws_iam_role" "face2gen_automation_dev_cluster" {
  name = var.face2gen_automation_dev_cluster_role_name
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

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy_attachment" {
  role = aws_iam_role.face2gen_automation_dev_cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController_attachment" {
  role = aws_iam_role.face2gen_automation_dev_cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "f_item_automation_dev_cluster" {
  name = var.face2gen_automation_dev_cluster_role_policy
  role = aws_iam_role.face2gen_automation_dev_cluster.id
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup"
          ],
          "Effect": "Deny",
          "Resource": "arn:aws:logs:eu-west-1:343434343434:log-group:/aws/eks/f_item-automation-dev/cluster"
        }
      ]
    }
  )
}

resource "aws_iam_role" "on_demand_eks_node_group" {
  name = var.on_demand_eks_node_group_role_name
  description = "EKS managed node group IAM role"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Sid = "EKSNodeAssumeRole"
        },
      ]
      Version   = "2012-10-17"
    }
  )
  tags = {
    environment = "automation-dev"
  }
  tags_all = {
    environment = "automation-dev"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonRekognitionFullAccess_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy" "AdminUpdateUserAttributes" {
  name = var.AdminUpdateUserAttributesp_role_policy
  role = aws_iam_role.on_demand_eks_node_group.id
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                  "cognito-idp:AdminUpdateUserAttributes",
                  "cognito-idp:AdminGetUser"
                ],
                "Resource": "*"
            }
        ]
    }
  )
}

resource "aws_iam_role_policy" "CloudWatchRW" {
  name = var.CloudWatchRW_role_policy
  role = aws_iam_role.on_demand_eks_node_group.id
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
          ],
          "Resource": [
            "arn:aws:logs:*:*:*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "PhoneNumberValidate" {
  name = var.PhoneNumberValidate_role_policy
  role = aws_iam_role.on_demand_eks_node_group.id
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "mobiletargeting:PhoneNumberValidate"
                ],
                "Resource": "*"
            }
        ]
    }
  )
}

resource "aws_iam_policy" "s3_bucket_access_automation_dev" {
  description = "Policy for exeternal s3 bucket access"
  name = var.s3_bucket_access_automation_dev_policy
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
                    "arn:aws:s3:::comp-automation-dev-config/*"
                ]
            },
            {
                "Action": [
                    "s3:ListBucket"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-automation-dev-config"
                ]
            },
            {
                "Action": "s3:*",
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-user-bl_item-staging",
                    "arn:aws:s3:::comp-user-bl_item-staging/*"
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
            }
        ],
        "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "s3_bucket_access_automation_dev_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = aws_iam_policy.s3_bucket_access_automation_dev.arn
}

resource "aws_iam_policy" "ebs_csi_driver_automation" {
  name = var.ebs_csi_driver_automation_policy
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

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_stage_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = aws_iam_policy.ebs_csi_driver_automation.arn
}

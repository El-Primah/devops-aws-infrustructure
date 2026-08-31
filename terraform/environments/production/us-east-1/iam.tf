resource "aws_iam_role" "dfg_us_site_cluster" {
  name = "f_item-us-site-cluster-20231006104909928100000007"
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
  role = aws_iam_role.dfg_us_site_cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  role = aws_iam_role.dfg_us_site_cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "dfg_us_site_cluster" {
  name = "f_item-us-site-cluster"
  role = aws_iam_role.dfg_us_site_cluster.id
  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup"
          ],
          "Effect": "Deny",
          "Resource": "arn:aws:logs:us-east-1:939393939393:log-group:/aws/eks/f_item-us-site/cluster"
        }
      ],
      "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role" "on_demand_eks_node_group" {
  name = var.iam_role_on_demand_eks_node_group_name
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
    environment = "us-site"
  }
  tags_all = {
    environment = "us-site"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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



/*
resource "aws_iam_role_policy" "AdminUpdateUserAttributes" {
  name = var.iam_role_policy_AdminUpdateUserAttributes
  role = aws_iam_role.on_demand_eks_node_group.id
  policy = jsonencode(
    {
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Action": "cognito-idp:AdminUpdateUserAttributes",
          "Effect": "Allow",
          "Resource": "arn:aws:cognito-idp:eu-west-1:343434343434:userpool/eu-west-1_JmsrCeQjn"
        }
      ],
      "Version": "2012-10-17"
    }
  )
}
*/

resource "aws_iam_role_policy" "CloudWatchRW" {
  name = "CloudWatchRW"
  role = aws_iam_role.on_demand_eks_node_group.id
  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
          ],
          "Effect": "Allow",
          "Resource": [
            "arn:aws:logs:*:*:*"
          ]
        }
      ],
      "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_us_site_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = aws_iam_policy.ebs_csi_driver_us_site.arn
}

resource "aws_iam_policy" "ebs_csi_driver_us_site" {
  name = var.iam_policy_ebs_csi_driver_us_site_nane
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


resource "aws_iam_role_policy_attachment" "s3_bucket_access_us_site_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::939393939393:policy/s3-bucket-access-us-site"
}

resource "aws_iam_policy" "s3_bucket_access_us_site" {
  name        = "s3-bucket-access-us-site"
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
                    "arn:aws:s3:::comp-us-site-config/*"
                ]
            },
            {
                "Action": [
                    "s3:ListBucket"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-us-site-config"
                ]
            },
            {
                "Action": [
                    "s3:*"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-user-bl_item-us/*",
                    "arn:aws:s3:::comp-user-bl_item-us",
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
                    "${aws_s3_bucket.genomic_docs.arn}",
                    "${aws_s3_bucket.genomic_docs.arn}/*"
                ]
            },
            {
                "Action": [
	                "kms:generateDataKey",
	                "kms:Decrypt"
                ]
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:kms:us-east-1:939393939393:key/mrk-b779a14d1fab4241aafcb371f129586a"
                ]
            }
        ],
        "Version": "2012-10-17"
    }
 )
}

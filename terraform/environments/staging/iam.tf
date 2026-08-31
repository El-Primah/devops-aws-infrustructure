resource "aws_iam_role" "comp_tf_stage_cluster" {
  name = var.eks_cluster_role
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
  role = aws_iam_role.comp_tf_stage_cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  role = aws_iam_role.comp_tf_stage_cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy" "comp_tf_stage_cluster" {
  name = var.iam_policy_comp_tf_eks_cluster
  role = aws_iam_role.comp_tf_stage_cluster.id
  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup"
          ],
          "Effect": "Deny",
          "Resource": "arn:aws:logs:eu-west-1:${var.aws_account_id}:log-group:/aws/eks/comp-tf-stage/cluster"
        }
      ],
      "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role" "on_demand_eks_node_group" {
  name = var.iam_role_on_demand_eks_node_group
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
    environment = var.stage_environment
  }
  tags_all = {
    environment = var.stage_environment
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

resource "aws_iam_role_policy_attachment" "AmazonCognitoPowerUser_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}

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
          "Resource": "arn:aws:cognito-idp:eu-west-1:${var.aws_account_id}:userpool/eu-west-1_JmsrCeQjn"
        }
      ],
      "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy" "CloudWatch" {
  name = var.iam_role_policy_CloudWatch
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

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_stage_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = aws_iam_policy.ebs_csi_driver_stage.arn
}

resource "aws_iam_policy" "ebs_csi_driver_stage" {
  name = var.iam_policy_ebs_csi_driver
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

resource "aws_iam_role_policy_attachment" "Route53_recordset_modify_stage_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/Route53-recordset-modify-stage"
}

resource "aws_iam_policy" "route53_recordset_modify_stage" {
  name = var.iam_policy_route53_recordset_modify
  description      = "Policy for Kubernetes exeternalDNS addone to change records in Route 53 hosted zone"
  policy = jsonencode(
    {
        "Statement": [
            {
                "Action": [
                    "route53:ChangeResourceRecordSets"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:route53:::hostedzone/*"
                ]
            },
            {
                "Action": [
                    "route53:ListHostedZones",
                    "route53:ListResourceRecordSets"
                ],
                "Effect": "Allow",
                "Resource": [
                    "*"
                ]
            }
        ],
        "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "s3_bucket_access_stage_attachment" {
  role = aws_iam_role.on_demand_eks_node_group.id
  policy_arn = "arn:aws:iam::${var.aws_account_id}:policy/s3-bucket-access-stage"
}

resource "aws_iam_policy" "s3_bucket_access_stage" {
  name = var.iam_policy_s3_bucket_access
  description      = "Policy for exeternal s3 bucket access"
  policy = jsonencode(
    {
        "Statement": [
            {
                "Action": [
                    "s3:GetObject"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-staging-config/*"
                ]
            },
            {
                "Action": [
                    "mobiletargeting:PhoneNumberValidate"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:mobiletargeting:eu-west-1:${var.aws_account_id}:phone/number/validate"
                ]
            },
            {
                "Action": [
                    "s3:ListBucket"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-staging-config"
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
                    "arn:aws:s3:::datasets-for-crop-job/*",
                    "arn:aws:s3:::comp-genomic-documents",
                    "arn:aws:s3:::comp-genomic-documents/*"
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
                "Action": "s3:*",
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-abc-public-staging",
                    "arn:aws:s3:::comp-abc-public-staging/*"
                ]
            },
            {
                "Action": "s3:*",
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::comp-que_app-assessments",
                    "arn:aws:s3:::comp-que_app-assessments/*"
                ]
            },
            {
                "Action": "s3:*",
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::library-es-backup",
                    "arn:aws:s3:::library-es-backup/*"
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
                    "arn:aws:s3:::comp-portal",
                    "arn:aws:s3:::comp-portal/*"
                ]
            }
        ],
        "Version": "2012-10-17"
    }
 )
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

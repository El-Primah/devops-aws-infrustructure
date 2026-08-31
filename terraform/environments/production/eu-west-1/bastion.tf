resource "aws_instance" "bastion" {
  ami           = "ami-0628d1f90060c2cdf"
  instance_type = "t2.micro"
  
  subnet_id              = module.vpc.subnets["utility_eu_west_1a"].id
  vpc_security_group_ids = [
    "sg-06ad43ff120163065",
    module.vpc.security_groups["prodenv_bastionhost_sg"].id
  ]
  iam_instance_profile   = aws_iam_role.comp_terraform_role.name
  key_name               = "opsmaster"
  
  associate_public_ip_address = true

  root_block_device {
    volume_size   = 20
  }
  tags = {
    Name = var.eks_bastion_name
  }

  #user_data = templatefile("${path.module}/templates/bastion_userdata_new.tftpl", {
  #  cluster_version   = "1.32"
  #})

  depends_on = [
    aws_eks_node_group.default,
    module.eks
  ]
}

resource "aws_iam_role" "comp_terraform_role" {
  name        = "comp-prod-terraform-role"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::343434343434:role/Jenkins-devops-slave"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "comp_terraform_role_s3_read_only_access" {
  role = aws_iam_role.comp_terraform_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy" "comp_terraform_role_access_to_dev" {
  name = "AccessToDevViaSTS"
  role = aws_iam_role.comp_terraform_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession",
                "sts:SetSourceIdentity",
                "sts:AssumeRoleWithWebIdentity"
            ],
            "Resource": "arn:aws:iam::343434343434:role/Jenkins-devops-slave"
        }
    ]
  })
}

resource "aws_iam_role_policy" "comp_terraform_role_copy_prod_to_us" {
  name = "copy-prod-to-us"
  role = aws_iam_role.comp_terraform_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::comp-eu-us-migrations",
                "arn:aws:s3:::comp-eu-us-migrations/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::comp-us-user-bl_item/*",
                "arn:aws:s3:::comp-us-user-bl_item"
            ]
        },
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "kms:generateDataKey"
            ],
            "Resource": "arn:aws:kms:us-east-1:${data.aws_caller_identity.current.account_id}:key/mrk-b779a14d1fab4241aafcb371f129586a"
        }
    ]
  })
}

resource "aws_iam_role_policy" "comp_terraform_role_kms_decrypt" {
  name = "KMSDecrypt"
  role = aws_iam_role.comp_terraform_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/b51ff8e8-4246-4382-8820-724a199eb1ca"
            ]
        }
    ]
  })
}

resource "aws_iam_role_policy" "comp_terraform_role_s3_portal_copy" {
  name = "s3-portal-copy"
  role = aws_iam_role.comp_terraform_role.id
  policy = jsonencode({
    "Statement": [
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::comp-portal",
                "arn:aws:s3:::comp-portal/*"
            ]
        },
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::comp-portal-prod",
                "arn:aws:s3:::comp-portal-prod/*"
            ]
        }
    ],
    "Version": "2012-10-17"
  })
}

resource "aws_iam_role_policy" "comp_terraform_role_SSM" {
  name = "SSM"
  role = aws_iam_role.comp_terraform_role.id
  policy = jsonencode({
      "Statement": [
        {
          "Action": [
			"ssm:UpdateInstanceInformation",
			"ssm:ListInstanceAssociations",
			"ssm:DescribeInstanceInformation",
			"ssmmessages:CreateControlChannel",
			"ssmmessages:CreateDataChannel",
			"ssmmessages:OpenControlChannel",
			"ssmmessages:OpenDataChannel",
			"ec2messages:AcknowledgeMessage",
			"ec2messages:DeleteMessage",
			"ec2messages:FailMessage",
			"ec2messages:GetEndpoint",
			"ec2messages:GetMessages",
			"ec2messages:SendReply"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ],
      "Version": "2012-10-17"
    })
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

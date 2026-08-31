resource "aws_instance" "bastion" {
  ami           = "ami-08d4ac5b634553e16"
  instance_type = "t3.medium"
  
  subnet_id              = module.vpc.subnets["public1"].id
  vpc_security_group_ids = [module.vpc.security_groups["us_site_env_bastionhost_sg"].id]
  iam_instance_profile   = "comp-dr-terraform-role"
  key_name               = "comp-us-site-devops"
  
  associate_public_ip_address = true

  root_block_device {
    volume_size   = 20
  }
  tags = {
    Name = var.eks_bastion_name
  }

  user_data = templatefile("${path.module}/templates/bastion_userdata_new.tftpl", {
    cluster_version   = "1.30"
    
 })
  depends_on = [aws_iam_role.comp_dr_terraform_role]
  
  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "aws_iam_role" "comp_dr_terraform_role" {
  name        = "comp-dr-terraform-role"
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

resource "aws_iam_role_policy_attachment" "comp_dr_terraform_role_attachment" {
  role = aws_iam_role.comp_dr_terraform_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy" "SSM" {
  name = "SSM"
  role = aws_iam_role.comp_dr_terraform_role.id
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

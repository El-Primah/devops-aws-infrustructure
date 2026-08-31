locals {
  base_policy_statements = {
    Sid    = "ExportAmazonEC2ContainerRegistryReadOnly"
    Effect = "Allow"
    Principal = {
      AWS = [
        "arn:aws:iam::101010101010:root",
        "arn:aws:iam::323232323232:root",
        "arn:aws:iam::343434343434:root",
        "arn:aws:iam::555555555555:root",
        "arn:aws:iam::565656565656:root",
        "arn:aws:iam::727272727272:root",
        "arn:aws:iam::852852852852:root",
        "arn:aws:iam::857857585857:root",
        "arn:aws:iam::868686868686:root",
        "arn:aws:iam::919191919191:root",
        "arn:aws:iam::939393939393:role/bastions.y_app.comp.com",
        "arn:aws:iam::939393939393:root"
      ]
    }
    Action = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:UploadLayerPart",
      "ecr:TagResource",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:StartImageScan",
      "ecr:SetRepositoryPolicy",
      "ecr:ReplicateImage",
      "ecr:PutRegistryPolicy",
      "ecr:PutLifecyclePolicy",
      "ecr:PutImageTagMutability",
      "ecr:PutImageScanningConfiguration",
      "ecr:PutImage",
      "ecr:ListTagsForResource",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetLifecyclePolicy",
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeImageReplicationStatus",
      "ecr:DescribeImages",
      "ecr:CompleteLayerUpload",
      "ecr:BatchImportUpstreamImage",
      "ecr:BatchGetRepositoryScanningConfiguration"
    ]
  }

  lambda_policy_statement = {
    Sid       = "LambdaECRImageRetrievalPolicy"
    Effect    = "Allow"
    Principal = {
      Service = "lambda.amazonaws.com"
    }
    Action = [
      "ecr:BatchGetImage",
      "ecr:DeleteRepositoryPolicy",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:SetRepositoryPolicy"
    ]
    Condition = {
      StringLike = {
        "aws:sourceArn" = "arn:aws:lambda:eu-west-1:343434343434:function:*"
      }
    }
  }
}

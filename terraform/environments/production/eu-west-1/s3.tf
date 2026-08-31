resource "aws_s3_bucket" "genomic_docs" {
  bucket = "comp-genomic-documents-eu"

  tags = {
    Name        = "comp Genomic Documents"
    Environment = "EU Prod"
  }
}

resource "aws_s3_bucket_versioning" "genomic_docs_versioning" {
  bucket = aws_s3_bucket.genomic_docs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "genomic_docs_policy" {
  bucket = aws_s3_bucket.genomic_docs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::939393939393:role/on-demand-eks-node-group-20230806032226790900000006"
        }
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.genomic_docs.arn}",
          "${aws_s3_bucket.genomic_docs.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket" "user_bl_item" {
  bucket = "comp-user-bl_item-production"

  tags = {
    Team = "DevOps"
  }
}

resource "aws_s3_bucket_versioning" "user_bl_item_versioning" {
  bucket = aws_s3_bucket.user_bl_item.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -- outputs for replication to dr --
output "genomic_docs_id" {
  value = aws_s3_bucket.genomic_docs.id
}

output "user_bl_item_id" {
  value = aws_s3_bucket.user_bl_item.id
}

resource "aws_s3_bucket" "genomic_docs" {
  bucket = "comp-genomic-documents-us"
  acl    = "private"

  tags = {
    Name        = "comp Genomic Documents"
    Environment = "US Prod"
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
          AWS = aws_iam_role.on_demand_eks_node_group.arn
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

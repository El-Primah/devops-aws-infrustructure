resource "aws_s3_bucket" "dr_bucket" {
  bucket = "comp-disaster-recovery-config"
}

resource "aws_s3_bucket_versioning" "dr_bucket" {
  bucket = aws_s3_bucket.dr_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "dr_bucket" {
  bucket = aws_s3_bucket.dr_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "dr_bucket" {
  bucket = aws_s3_bucket.dr_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.config_aws_account_ID}:role/s3-replication-role"
        }
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          "${aws_s3_bucket.dr_bucket.arn}/*"
        ]
      }
    ]
  })
}

output "dr_bucket_arn" {
  value = aws_s3_bucket.dr_bucket.arn
}


# --- comp-genomic-documents-dr Replication ---
resource "aws_s3_bucket" "genomic_docs_dr" {
  bucket = "comp-genomic-documents-dr"
}

resource "aws_s3_bucket_versioning" "genomic_docs_dr" {
  bucket = aws_s3_bucket.genomic_docs_dr.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "genomic_docs_dr" {
  bucket = aws_s3_bucket.genomic_docs_dr.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "genomic_docs_dr" {
  bucket = aws_s3_bucket.genomic_docs_dr.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.eu_west_1_prod_account_id}:role/genomic-docs-replication"
        }
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          "${aws_s3_bucket.genomic_docs_dr.arn}/*"
        ]
      }
    ]
  })
}

output "genomic_docs_dr_arn" {
  value = aws_s3_bucket.genomic_docs_dr.arn
}


# --- comp-user-bl_item Replication ---
resource "aws_s3_bucket" "user_bl_item_dr" {
  bucket = "comp-user-bl_item-disaster-recovery"
}

resource "aws_s3_bucket_versioning" "user_bl_item_dr" {
  bucket = aws_s3_bucket.user_bl_item_dr.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "user_bl_item_dr" {
  bucket = aws_s3_bucket.user_bl_item_dr.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "user_bl_item_dr" {
  bucket = aws_s3_bucket.user_bl_item_dr.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.eu_west_1_prod_account_id}:role/user-bl_item-replication"
        }
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = [
          "${aws_s3_bucket.user_bl_item_dr.arn}/*"
        ]
      }
    ]
  })
}

output "user_bl_item_dr_arn" {
  value = aws_s3_bucket.user_bl_item_dr.arn
}

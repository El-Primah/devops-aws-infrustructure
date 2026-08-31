resource "aws_s3_bucket" "config_bucket" {
  bucket = var.config_bucket_name
}

resource "aws_s3_bucket_versioning" "config_bucket_versioning" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  role   = aws_iam_role.s3_replication.arn
  bucket = aws_s3_bucket.config_bucket.id

  rule {
    id     = "cross-account-replication"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket        = var.dr_bucket_arn
      account       = var.target_replication_AWS_account_ID
      access_control_translation {
        owner = "Destination"
      }
    }

    delete_marker_replication {
      status = "Disabled"
    }
  }
}

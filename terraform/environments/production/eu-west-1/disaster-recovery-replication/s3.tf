resource "aws_s3_bucket_replication_configuration" "genomic_docs_replication" {
  role   = aws_iam_role.genomic_docs_replication.arn
  bucket = local.genomic_docs_id

  rule {
    id     = "cross-account-replication"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket        = var.genomic_docs_dr_arn
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

resource "aws_s3_bucket_replication_configuration" "user_bl_item_replication" {
  role   = aws_iam_role.user_bl_item_replication.arn
  bucket = local.user_bl_item_id

  rule {
    id     = "cross-account-replication"
    status = "Enabled"

    filter {
      prefix = ""
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = var.user_bl_item_dr_arn
      account       = var.target_replication_AWS_account_ID
      access_control_translation {
        owner = "Destination"
      }
      encryption_configuration {
        replica_kms_key_id = "arn:aws:kms:${var.dr_region}:${var.target_replication_AWS_account_ID}:key/${var.user_bl_item_dr_kms_key_id}"
      }
    }

    delete_marker_replication {
      status = "Disabled"
    }
  }
}

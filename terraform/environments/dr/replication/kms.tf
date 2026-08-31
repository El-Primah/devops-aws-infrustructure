resource "aws_kms_key" "user_bl_item_key" {
  description             = "Destination bucket KMS key"
  deletion_window_in_days = 10
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "EnableRootPermissions",
        Effect   = "Allow",
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid      = "AllowReplicationRoleUseOfKey",
        Effect   = "Allow",
        Principal = { AWS = "arn:aws:iam::${var.eu_west_1_prod_account_id}:role/user-bl_item-replication" },
        Action   = ["kms:Encrypt", "kms:generateDataKey"],
        Resource = "*"
      }
    ]
  })
}

output "bl_item_bucket_kms_key_id" {
  value = aws_kms_key.user_bl_item_key.id
}

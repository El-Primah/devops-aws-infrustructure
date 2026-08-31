variable "dr_bucket_arn" {
  description = "ARN of bucket in DR"
  type        = string
  default     = "arn:aws:s3:::comp-disaster-recovery-config"
}

variable "config_bucket_name" {
  default = "comp-production-config"
}

variable "target_replication_AWS_account_ID" {
  default = "101010101010"
}

variable "s3_replication_role" {
  default = "s3-replication-role"
}

variable "s3_replication_policy" {
  default = "s3-replication-policy"
}

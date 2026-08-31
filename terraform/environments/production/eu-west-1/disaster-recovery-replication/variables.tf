variable "environment" {
  default = "prod"
}

variable "dr_region" {
  description = "AWS Disaster Recovery account region"
  type        = string
  default     = "eu-central-1"
}

# --- vars for s3 replication
variable "target_replication_AWS_account_ID" {
  default = "101010101010"
}

variable "genomic_docs_dr_arn" {
  description = "ARN of comp-genomic-documents-eu bucket in DR"
  type        = string
  default     = "arn:aws:s3:::comp-genomic-documents-dr"
}

variable "user_bl_item_dr_arn" {
  description = "ARN of comp-genomic-documents-eu bucket in DR"
  type        = string
  default     = "arn:aws:s3:::comp-user-bl_item-disaster-recovery"
}

variable "user_bl_item_dr_kms_key_id" {
  description = "ID of kms key in DR for bl_item bucket encryption"
  type        = string
  default     = "e9c0f9c8-23dc-415d-acea-c9bc9869d357"
}

# --- vars for RDS Lambda --
variable "lambda_create_snapshot" {
  default = "create-rds-snapshot"
}

variable "lambda_share_snapshot" {
  default = "share-rds-snapshot"
}

variable "lambda_delete_snapshot" {
  default = "delete-rds-snapshot"
}

variable "lambda_copy_snapshot" {
  default = "copy-rds-snapshot"
}

variable "lambda_get_snapshot_status" {
  default = "get-rds-snapshot-status"
}

variable "lambda_role_name" {
  default = "rds-snapshot-lambda-role"
}

variable "lambda_policy_name" {
  default = "rds-snapshot-lambda-policy"
}

# -- vars for Scheduler ---
variable "scheduler_role" {
  default = "StateMachineForSnapshots-SchedulerRole"
}

variable "schedule_name" {
  default = "daily-schedule-for-statemachine"
}

# --- vars for StateMachine ---
variable "rds_lambda_state_machine_name" {
  default = "rds-copy-share"
}

variable "rds_lambda_state_machine_role" {
  default = "state-machine-rds-copy-share"
}

variable "rds_lambda_state_machine_role_policy" {
  default = "state-machine-rds-describe"
}

# Use data.aws_region.current.name instead var.region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  type        = string
  default     = "dr"
}

# --- config AWS account id ---
variable "config_aws_account_ID" {
  default = "919191919191"
}

# --- eu-west-1 AWS account ID ---
variable "eu_west_1_prod_account_id" {
  default = "939393939393"
}


# --- vars for Scheduler ---
variable "scheduler_role" {
  default = "StateMachineForSnapshots-SchedulerRole"
}

variable "schedule_name" {
  default = "daily-schedule-for-statemachine"
}

# --- vars for StateMachine ---
variable "rds_lambda_state_machine_name" {
  default = "rds-copy-delete"
}

variable "rds_lambda_state_machine_role" {
  default = "state-machine-rds-copy-delete"
}

variable "rds_lambda_state_machine_role_policy" {
  default = "state-machine-rds-describe"
}

variable "rds_instance_name_for_snapshot_lambda" {
  default = "prodmysql-y_app"
}

# --- vars for Lambda ---
variable "lambda_copy_snapshot" {
  default = "dr-copy-shared-snapshot"
}

variable "lambda_delete_snapshots" {
  default = "dr-lambda-delete-snapshots"
}

variable "lambda_role_name" {
  default = "dr-copy-snapshot-lambda-role"
}

variable "lambda_policy_name" {
  default = "dr-copy-snapshot-lambda-policy"
}



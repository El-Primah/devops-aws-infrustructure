
# Use  "data.aws_region.current.name"  instead var.region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  type        = string
  default     = "dr"
}

variable "dr_bucket_name" {
  default = "comp-disaster-recovery-config"
}

# --- vars for meme-gateway LB ---
variable "lb_name" {
  default = "meme-gateway"
}

variable "tg_https_443" {
  default = "meme-gateway-https"
}

variable "tg_http_80" {
  default = "meme-gateway-http"
}

variable "tg_https_443_port" {
  default = 30517
}

variable "tg_http_80_port" {
  default = 32379
}


# --- vars for Lambda funtions for cognito ---
variable "lambda_cognito_iam_resources_path" {
  default = "/service-role/"
}

variable "cognito_code_template" {
  default = "cognito-code-template"
}

variable "define_auth_challenge" {
  default = "DefineAuthChallenge"
}

variable "create_auth_challenge" {
  default = "CreateAuthChallenge"
}

variable "verify_auth_challenge_response" {
  default = "VerifyAuthChallengeResponse"
}

variable "lambda_congito_consumer_role" {
  default = "cognito-code-template-role-xsat3rv7"
}

variable "lambda_congito_consumer_basic_execution_policy" {
  default = "AWSLambdaBasicExecutionRole-31e89a91-6b2d-4e30-813d-aaccb42b03dd"
}

variable "lambda_congito_consumer_tracer_access_execution_policy" {
  default = "AWSLambdaTracerAccessExecutionRole-b521e185-b154-48b4-8406-3106a793885a"
}

variable "lambda_insights_extension_layer_arn" {
  default = "arn:aws:lambda:eu-west-1:585858585858:layer:LambdaInsightsExtension:45"
}

# --- vars for Cognito ---
variable "cognito_user_pool_consumer_name" {
  default = "consumer-cognito-dr"
}

variable "cognito_user_pool_cor_item_name" {
  default = "cor_item-cognito-dr"
}

variable "cognito_sms_external_id" {
  default = "b3189deb-86f7-49b0-a938-55d7c719b07e"
}

# --- vars for APIGW ---
variable "stage_var_api_dns" {
  default = "api.test.dr.com"
}

# --- vars for CONSUMER APIGW ---
variable "apigw_consumer_name" {
  default = "api-consumer-dr-com"
}

variable "apigw_consumer_stage_name" {
  default = "dr"
}

variable "apigw_consumer_tag" {
  default = "dr"
}

variable "consumer_com_api_auth_name" {
  default = "consumer_api_gateway_authorizer"
}

# --- vars for cor_item APIGW ---
variable "apigw_cor_item_name" {
  default = "api-cor_item-dr-com"
}

variable "apigw_cor_item_stage_name" {
  default = "deploy"
}

variable "cor_item_com_api_auth_name" {
  default = "cor_item_api_gateway_authorizer"
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
  default = "stagingmysql-y_app"
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


# --- vars for DR EKS ---
variable "eks_cluster_name" {
  default = "f_item-dr"
}

variable "eks_version" {
  default = "1.32"
}

variable "eks_default_node_group_name" {
  description = "name for default Node group in DR eks cluter"
  default     = "dr-default"
}

variable "eks_bastion_instance" {
  description = "name for DR eks bastion instance "
  default = "bastion-dr-env-eks"
}

variable "ebs_csi_driver_role" {
  default = "f_item-dr-AmazonEKS_EBS_CSI_DriverRole"
}

variable "eks_node_group_launch_template" {
  default = "eks-node-group-launch-template"
}

# vars for bastion iam
variable "bastion_eks_access_role" {
  default = "BastionEKSAccess"
}

variable "eks_ro" {
  default = "EKSRO"
}

variable "bastion_eks_access_profile" {
  default = "BastionEKSAccess"
}


# --- vars for DR RDS created from db snapshot ---
#variable "rds_name" {
#  description = "RDS name to take snapshot from (exported from APIGW-RDS scripd)"
#  type    = string
#  default = ""
#}

variable "snapshot_arn" {
  description = "Current snapshot to create rds from (exported from APIGW-RDS scripd)"
  type    = string
  default = ""
}

variable "restored_db_new_subnet_group_name" {
  description = "name of subnet_group for DR RDS created from db snapshot"
  default     = "dr-db-subnet-group"
}

variable "snapshot_restored_db_name" {
  type = string
  description = "identifier of restored from snapshot DR RDS"
  default = "snapshot-restored-mysql-dr-instance"
}

# --- vars for IAM ---
variable "congito_sms_role" {
  default = "cognito-sms-role"
}

variable "policy_cognito_1616161616161_for_congito_sms_role" {
  default = "Cognito-1616161616161"
}

variable "eks_cluster_role_name" {
  default = "f_item-dr-cluster"
}

variable "eks_node_role_name" {
  default = "eks-node-group-dr"
}

variable "deny_logs_cluster_name" {
  default = "deny-cluster-loggroup-create"
}

variable "admin_update_user_name" {
  description = "name for Inline node policy admin_update_user"
  default     = "AdminUpdateUserAttributes"
}

variable "cloudwatch_rw_name" {
  description = "name for Inline node policy cloudwatch_rw"
  default     = "CloudWatchRW"
}

variable "phone_validate_name" {
  description = "name for Inline node policy phone_validate"
  default     = "PhoneNumberValidate"
}

variable "eks_access_to_s3" {
  description = "name for S3 Custom Policy policy s3_access_dr"
  default     = "s3-bucket-access-dr"
}

variable "ebs_csi_driver_policy" {
  description = "name for CSI EBS Driver Policy ebs_csi_driver_dr"
  default     = "ebs-csi-driver-dr"
}

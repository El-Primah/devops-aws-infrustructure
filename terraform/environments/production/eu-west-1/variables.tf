variable "environment" {
  type        = string
  default     = "prod"
}

# --- vars for EKS ---
variable "eks_cluster_name" {
  default = "comp-tf-production"
}

variable "eks_version" {
  default = "1.32"
}

variable "eks_default_node_group_name" {
  default = "on-demand-10000000000000000000000002"
}

variable "eks_node_group_launch_template" {
  default = "eks-on-demand-10000000000000000000000002-b4c4e486-b645-307c-701f-1931aa83bb51"
}

variable "eks_bastion_name" {
  default = "bastion-prod-eks-env"
}

# --- vars for Lambda funtions for cognito ---
variable "service_role_iam_resources_path" {
  default = "/service-role/"
}

variable "cognito_code_template" {
  default = "cognito-code-template"
}

variable "lambda_congito_role" {
  default = "cognito-code-template-role-gwh8euwo"
}

variable "lambda_congito_basic_execution_policy" {
  default = "AWSLambdaBasicExecutionRole-0c104e78-6faa-43bc-b929-bdebdda1ce4f"
}

variable "lambda_congito_tracer_access_execution_policy" {
  default = "AWSLambdaTracerAccessExecutionRole-b521e185-b154-48b4-8406-3106a793885a"
}

variable "lambda_insights_extension_layer_arn" {
  default = "arn:aws:lambda:eu-west-1:585858585858:layer:LambdaInsightsExtension:45"
}

# --- vars for Cognito ---
variable "cognito_user_pool_abc_name" {
  default = "comp-abc-cognito-prod"
}

variable "cognito_user_pool_cor_item_name" {
  default = "comp-abc-cor_item-cognito-prod"
}

# --- vars for IAM ---
variable "eks_cluster_role_name" {
  default = "comp-tf-production-cluster-20230806040536843200000001"
}

variable "eks_cluster_role_policy_log_group_name" {
  default = "comp-tf-production-cluster"
}

variable "eks_node_role_name" {
  default = "on-demand-eks-node-group-20230806032226790900000006"
}

variable "admin_update_user_name" {
  default = "AdminUpdateUSerAttributes"
}

variable "kms_decrypt_name" {
  default = "allow-kms-decrypt"
}

variable "cloudwatch_rw_name" {
  default = "CloudWatchRW"
}

variable "ebs_csi_driver_policy_name" {
  default  = "ebs-csi-prodiver-prod-new"
}

variable "s3_access_prod_name" {
  default = "s3-bucket-access-prod-new"
}


# --- global vars
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_account_id" {
  description = "ID of aWS account where this terraform configuration is applied"
  type        = string
  default     = "343434343434"
}

variable "environment" {
  type        = string
  default     = "staging"
}

variable "stage_environment"{
	default = "stage"
}

variable "nonprod_environment" {
	default = "nonprod"
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
  default = "consumer-cognito-staging"
}

variable "cognito_user_pool_cor_item_name" {
  default = "cor_item-cognito-staging"
}

variable "cognito_sms_external_id" {
  default = "b3189deb-86f7-49b0-a938-55d7c719b07e"
}

# --- vars for APIGW ---
variable "stage_var_api_dns" {
  default = "api.staging.comp.com"
}

# --- vars for CONSUMER APIGW ---
variable "apigw_consumer_name" {
  default = "consumer-com-api"
}

variable "apigw_consumer_stage_name" {
  default = "staging"
}

variable "apigw_consumer_tag" {
  default = "dev"
}

variable "consumer_com_api_auth_name" {
  default = "consumer_api_gateway_authorizer"
}

# --- vars for cor_item APIGW ---
variable "apigw_cor_item_name" {
  default = "cor_item-com-api"
}

variable "apigw_cor_item_stage_name" {
  default = "deploy"
}

variable "cor_item_com_api_auth_name" {
  default = "cor_item_api_gateway_authorizer"
}




# VPC
variable "vpc_name_tag" {
	default = "comp-nonprod-vpc"
}

variable "sg_for_eks" {
	default = "sg-056f683219dd75acd"
	description = "Security group for stage EKS cluster"
}


# EKS
variable "authentication_mode" {
  default = "CONFIG_MAP"
}

variable "eks_version" {
  default = "1.32"
}

variable "eks_cluster_name" {
  default = "comp-tf-stage"
}

variable "eks_node_group_on_demand_name" {
  default = "on-demand-20230702130721158400000014"
}

variable "eks_node_group_on_demand_name_tag" {
  default = "on-demand"
}

variable "eks_node_group_r52xlarge_name" {
  default = "r52xlarge"
}


# IAM
variable "congito_sms_role" {
  default = "cognito-sms-role"
}

variable "policy_cognito_1616161616161_for_congito_sms_role" {
  default = "Cognito-1616161616161"
}

variable "eks_cluster_role"{
	default = "comp-tf-stage-cluster-20230702125815657100000005"
}

variable "iam_policy_comp_tf_eks_cluster"{
	default = "comp-tf-stage-cluster"
}

variable "iam_role_on_demand_eks_node_group"{
	default = "on-demand-eks-node-group-20230702125815954500000007"
}

variable "iam_role_policy_AdminUpdateUserAttributes"{
	default = "AdminUpdateUserAttributes"
}

variable "iam_role_policy_CloudWatch"{
	default = "CloudWatch"
}

variable "iam_policy_ebs_csi_driver"{
	default = "ebs-csi-driver-stage"
}

variable "iam_policy_route53_recordset_modify"{
	default = "Route53-recordset-modify-stage"
}

variable "iam_policy_s3_bucket_access"{
	default = "s3-bucket-access-stage"
}


# Route 53
variable "zone_f_item_com" {
	default = "staging.f_item.com"
}

variable "zone_comp_com" {
	default = "staging.comp.com"
}

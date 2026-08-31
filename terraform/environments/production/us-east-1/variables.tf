# --- vars for EKS ---
variable "eks_cluster_name" {
  default = "f_item-us-site"
}

variable "eks_version" {
  default = "1.32"
}

variable "eks_node_group_on_demand_name" {
  default     = "ondemand"
}

variable "eks_node_group_r52xlarge_name" {
  default     = "r52xlarge"
}

variable "eks_node_group_on_demand_r6i_name" {
  default     = "on-demand-r6i"
}

variable "authentication_mode" {
  default = "CONFIG_MAP"
}

variable "dfg_us_site_cluster_sg" {
  default = "sg-0d9953c7299f62903"
}

variable "eks_bastion_name" {
  default = "bastion-us-site-env-tf-eks"
}



# --- vars for external_comp_eks_ex ---
variable "comp_eks_ex_name" {
  default = "external-comp-eks-ex-20231006104909335700000001"
}

variable "comp_eks_ex_instance_name" {
  default = "eks-comp-us-site-tf-on-demand"
}

variable "comp_eks_ex_volume_name" {
  default = "eks-comp-us-site-tf-on-demand"
}



# --- vars for IAM ---
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
  default     = "AdminUpdateUserAttributes"
}

variable "cloudwatch_rw_name" {
  default     = "CloudWatchRW"
}

variable "phone_validate_name" {
  default     = "PhoneNumberValidate"
}

variable "s3_access_dr_name" {
  default     = "s3-bucket-access"
}

variable "iam_policy_ebs_csi_driver_us_site_nane" {
  default     = "ebs-csi-driver-us-site"
}

variable "iam_role_on_demand_eks_node_group_name" {
  default = "on-demand-eks-node-group-20231006104909797600000005"
}

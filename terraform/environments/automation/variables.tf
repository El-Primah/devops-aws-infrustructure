# --- vars for AUTOMATION EKS ---
variable "eks_cluster_name" {
  default = "f_item-automation-dev"
}

variable "eks_version" {
  default = "1.32"
}

variable "eks_node_group_name_default" {
  default     = "prod-copy"
}

variable "eks_node_group_name_encrypted" {
  default     = "prod-copy-encrypted"
}

variable "external_comp_eks_ex_name" {
  description = "EKS managed node group external launch template"
  default     = "automation-comp-eks-ex"
}


# --- vars for IAM ---
variable "face2gen_automation_dev_cluster_role_name" {
  default = "f_item-automation-dev-cluster-20240702064728625900000005"
}

variable "face2gen_automation_dev_cluster_role_policy" {
  default = "f_item-automation-dev-cluster"
}

variable "on_demand_eks_node_group_role_name" {
  default = "on-demand-eks-node-group-20240702064728727600000007"
}

variable "AdminUpdateUserAttributesp_role_policy" {
  default = "AdminUpdateUserAttributes"
}

variable "CloudWatchRW_role_policy" {
  default = "CloudWatchRW"
}

variable "PhoneNumberValidate_role_policy" {
  default = "PhoneNumberValidate"
}

variable "s3_bucket_access_automation_dev_policy" {
  description = "Policy for exeternal s3 bucket access"
  default = "s3-bucket-access-automation-dev"
}

variable "ebs_csi_driver_automation_policy" {
  description = "Policy for Kubernetes ebs-csi-driver to manage EBS volumes"
  default = "ebs-csi-driver-automation"
}



# --- vars for VPC ---
variable "vpc_this_name" {
  default  = "automation-vpc"
}

variable "vpc_igw_this_name" {
  default = "automation-igw"
}

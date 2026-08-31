variable "name" {
  description = "Name of the launch template"
  type        = string
}

variable "description" {
  description = "Description of the launch template"
  type        = string
}

variable "tags" {
  description = "Tags for the launch template"
  type        = map(string)
  default     = {}
}

variable "tags_all" {
  description = "All tags for the launch template"
  type        = map(string)
  default     = {}
}

variable "device_name" {
  description = "Device name for block device mapping"
  type        = string
  default     = "/dev/xvda"
}

variable "delete_on_termination" {
  description = "Whether the volume should be deleted on termination"
  type        = bool
  default     = true
}

variable "ebs_iops" {
  description = "IOPS for the EBS volume"
  type        = number
  default     = 0
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in GiB"
  type        = number
  default     = 200
}

variable "ebs_volume_type" {
  description = "Type of the EBS volume"
  type        = string
  default     = "gp3"
}

variable "kms_key_id" {
  description = "KMS key ID to use for the EBS volume"
  type        = string
  default     = ""
}

variable "encrypted" {
  description = "Encrypted state to use for the EBS volume"
  type        = string
  default     = ""
}

variable "tag_specifications" {
  description = "List of tag specifications for different resource types"
  type = list(object({
    resource_type = string
    tags          = map(string)
  }))
}


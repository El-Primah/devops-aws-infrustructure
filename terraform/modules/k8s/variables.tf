variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "authentication_mode" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "enabled_cluster_log_types" {
  type = list(string)
  default = []
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = false
}

variable "tags" {
  description = "Optional tags for the EKS cluster"
  type        = map(string)
  default     = {}

}

variable "node_groups" {
  type = map(object({
    subnet_ids          = list(string)
    node_role_arn       = string
    node_group_name     = string
    ami_type            = string
    capacity_type       = string
    disk_size           = number
    instance_types      = list(string)
    labels              = map(string)
    version             = string
    tags                = map(string)
    tags_all            = map(string)
    scaling = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    update_config = object({
      max_unavailable            = number
      max_unavailable_percentage = number
    })
    launch_template = object({
      id      = string
      version = string
    })
  }))
  default = {}
}

variable "vpc_cni_addon_config" {
  description = "Configuration for the VPC CNI addon."
  type = object({
    addon_version        = optional(string, null)
    configuration_values = optional(string, null)
    preserve             = optional(bool, false)
    resolve_conflicts_on_create = optional(string, "NONE")
    resolve_conflicts_on_update = optional(string, "NONE")
  })
  default = null
}

variable "kube_proxy_addon_config" {
  description = "Configuration for the Kube Proxy addon."
  type = object({
    addon_version        = optional(string, null)
    configuration_values = optional(string, null)
    preserve             = optional(bool, false)
    resolve_conflicts_on_create = optional(string, "NONE")
    resolve_conflicts_on_update = optional(string, "NONE")
  })
  default = null
}


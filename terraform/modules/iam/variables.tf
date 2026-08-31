variable "roles" {
  description = "Map of IAM roles to create. Key is the role name."
  type = map(object({
    assume_role_policy_json = string      # JSON string for assume_role_policy
    description             = optional(string, "")
    path                    = optional(string, "/")
    max_session_duration    = optional(number, 3600)
    force_detach_policies   = optional(bool, false)
    permissions_boundary    = optional(string, null)
    tags                    = optional(map(string), {})

    # Inline policies
    inline_policies = optional(map(object({
      policy = string # JSON string for policy
    })), {})

    # for ARNs of not-iniline policies (AWS managed, etc)
    attached_policy_arns = optional(list(string), [])
  }))
  default = {}
}

variable "policies" {
  description = "Map of IAM managed policies to create. Key is the policy name."
  type = map(object({
    policy      = string # JSON string for policy
    description = optional(string, "")
    path        = optional(string, "/")
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "instance_profiles" {
  description = "Map of IAM instance profiles to create. Key is the profile name."
  type = map(object({
    path = optional(string, "/")
    role = string
    tags = optional(map(string), {})
  }))
  default = {}
}
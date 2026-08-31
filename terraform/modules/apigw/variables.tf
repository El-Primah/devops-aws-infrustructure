variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "Description of the API Gateway"
  type        = string
  default     = ""
}

variable "minimum_compression_size" {
  default = null
}

variable "stage_name" {
  description = "Name of the deployment stage"
  type        = string
}

variable "authorizer_name" {
  description = "Name of the authorizer"
  type        = string
}

variable "authorizer_type" {
  description = "Type of the authorizer (for example COGNITO_USER_POOLS)"
  type        = string
  default     = "REQUEST"
}

variable "authorizer_provider_arns" {
  description = "Required for type COGNITO_USER_POOLS"
  type        = list(string)
  default     = []
}

variable "stage_variables" {
  description = "Variables for the stage"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for the API Gateway resources"
  type        = map(string)
  default     = {}
}

variable "binary_media_types" {
  description = "Binary media types"
  type        = list(string)
  default     = ["*/*"]
}

variable "resources" {
  description = "List of API resources to create"
  type = list(object({
    key       = string
    parent_key = string
    path_part = string
  }))
  default = []
}

variable "methods" {
  description = "List of API methods to create"
  type = list(object({
    key             = string
    resource_key    = string
    http_method     = optional(string)
    authorization   = string
    authorizer_id   = optional(string)
    
    integration = object({
      type                    = string
      uri                     = optional(string)
      integration_http_method = optional(string)
      passthrough_behavior    = optional(string)
      content_handling        = optional(string)
      request_templates       = optional(map(string))
    })
  }))
  default = []
}

variable "xray_tracing_enabled" {
  description = "Whether active tracing with X-Ray is enabled"
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

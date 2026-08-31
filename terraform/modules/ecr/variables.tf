variable "ecr_repositories_config" {
  description = "Map of ECR repositories with their configurations"
  type = map(object({
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, false)
  }))
}

variable "ecr_repos_with_lambda_policy" {
  description = "List of ECR repositories that need LambdaECRImageRetrievalPolicy"
  type        = list(string)
  default     = []
}

output "roles" {
  description = "Map of created IAM roles"
  value = aws_iam_role.this
}

output "policies" {
  description = "Map of created IAM policies"
  value = aws_iam_policy.this
}

output "instance_profiles" {
  description = "Map of created IAM instance profiles"
  value = aws_iam_instance_profile.this
}

output "role_arns" {
  description = "Map of ARNs of created IAM roles"
  value = {
    for k, v in aws_iam_role.this : k => v.arn
  }
}

output "policy_arns" {
  description = "Map of ARNs of created IAM policies"
  value = {
    for k, v in aws_iam_policy.this : k => v.arn
  }
}

output "instance_profile_arns" {
  description = "Map of ARNs of created IAM instance profiles"
  value = {
    for k, v in aws_iam_instance_profile.this : k => v.arn
  }
}
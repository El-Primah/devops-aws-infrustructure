# IAM Policies
resource "aws_iam_policy" "this" {
  for_each = var.policies

  name        = each.key
  description = each.value.description
  path        = each.value.path
  policy      = each.value.policy
  tags        = each.value.tags
}

# IAM Roles
resource "aws_iam_role" "this" {
  for_each = var.roles

  name                    = each.key
  description             = each.value.description
  assume_role_policy      = each.value.assume_role_policy_json
  path                    = each.value.path
  max_session_duration    = each.value.max_session_duration
  force_detach_policies   = each.value.force_detach_policies
  permissions_boundary    = each.value.permissions_boundary

  tags = each.value.tags
}

# Attachment outer policies to roles
resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for role_name, role_config in var.roles : # Check all roles
    for policy_arn in role_config.attached_policy_arns : # Get outer policy names in each role
    "${role_name}:${policy_arn}" => { # create unique id for each attachment
      role       = role_name
      policy_arn = policy_arn
    }
  }

  role       = aws_iam_role.this[each.value.role].name
  policy_arn = each.value.policy_arn
}

# Iniline role policies
resource "aws_iam_role_policy" "this" {
  for_each = {
    for role_name, role_config in var.roles : # Check all roles to get configs for iniline policies
    for policy_name, policy_config in role_config.inline_policies : # Check iniline policies for each role
    "${role_name}:${policy_name}" => { # Create unique id for every iniline policy and copy its config
      role_name = role_name
      policy_name = policy_name
      policy = policy_config.policy
    }
  }

  name   = each.value.policy_name
  role   = aws_iam_role.this[each.value.role_name].name
  policy = each.value.policy
}

# IAM instance profiles
resource "aws_iam_instance_profile" "this" {
  for_each = var.instance_profiles

  name = each.key
  path = each.value.path
  role = aws_iam_role.this[each.value.role].name # Required - sets role for instance profile

  tags = each.value.tags
}
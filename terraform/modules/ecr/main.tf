resource "aws_ecr_repository" "this" {
  for_each = var.ecr_repositories_config

  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability

  dynamic "item_scanning_configuration" {
    for_each = each.value.scan_on_push != null ? [1] : []
    content {
      scan_on_push = each.value.scan_on_push
    }
  }
}

resource "aws_ecr_repository_policy" "read_only" {
  for_each = var.ecr_repositories_config

  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = concat(
      [local.base_policy_statements],
      contains(var.ecr_repos_with_lambda_policy, each.key) ? [local.lambda_policy_statement] : []
    )
  })
}

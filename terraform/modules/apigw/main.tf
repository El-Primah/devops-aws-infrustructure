# ==================== API Gateway ====================

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_description

  binary_media_types = var.binary_media_types

  minimum_compression_size = var.minimum_compression_size

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# ======================== AUTHORIZER ========================

resource "aws_api_gateway_authorizer" "authorizer" {
  name        = var.authorizer_name
  rest_api_id = aws_api_gateway_rest_api.api.id
  
  type          = var.authorizer_type
  provider_arns = var.authorizer_provider_arns
}

# ==================== RESOURCES BY LEVELS ====================

locals {
  # Create lookup map for easy access
  resource_map = {
    for resource in var.resources : resource.key => resource
  }
  
  root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  
  # Level 1: direct children of root
  level1_keys = [
    for key, resource in local.resource_map : key if resource.parent_key == "root"
  ]
  
  level1_resources = {
    for key in local.level1_keys : key => local.resource_map[key]
  }
  
  # Level 2: children of level 1 resources
  level2_keys = [
    for key, resource in local.resource_map : key if 
    resource.parent_key != "root" && 
    contains(local.level1_keys, resource.parent_key)
  ]
  
  level2_resources = {
    for key in local.level2_keys : key => local.resource_map[key]
  }
  
  # Level 3: children of level 2 resources
  level3_keys = [
    for key, resource in local.resource_map : key if 
    resource.parent_key != "root" && 
    contains(local.level2_keys, resource.parent_key)
  ]
  
  level3_resources = {
    for key in local.level3_keys : key => local.resource_map[key]
  }
  
  # Level 4: children of level 3 resources
  level4_keys = [
    for key, resource in local.resource_map : key if 
    resource.parent_key != "root" && 
    contains(local.level3_keys, resource.parent_key)
  ]
  
  level4_resources = {
    for key in local.level4_keys : key => local.resource_map[key]
  }
  
  # Level 5: children of level 4 resources (if needed)
  level5_keys = [
    for key, resource in local.resource_map : key if 
    resource.parent_key != "root" && 
    contains(local.level4_keys, resource.parent_key)
  ]
  
  level5_resources = {
    for key in local.level5_keys : key => local.resource_map[key]
  }
  
  # Level 6: children of level 5 resources (if needed)
  level6_keys = [
    for key, resource in local.resource_map : key if 
    resource.parent_key != "root" && 
    contains(local.level5_keys, resource.parent_key)
  ]
  
  level6_resources = {
    for key in local.level6_keys : key => local.resource_map[key]
  }
}

# ==================== CREATE RESOURCES ====================

# Level 1 resources
resource "aws_api_gateway_resource" "level1" {
  for_each = local.level1_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = local.root_resource_id
  path_part   = each.value.path_part
}

# Level 2 resources
resource "aws_api_gateway_resource" "level2" {
  for_each = local.level2_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.level1[each.value.parent_key].id
  path_part   = each.value.path_part

  depends_on = [aws_api_gateway_resource.level1]
}

# Level 3 resources
resource "aws_api_gateway_resource" "level3" {
  for_each = local.level3_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = try(
    aws_api_gateway_resource.level2[each.value.parent_key].id,
    aws_api_gateway_resource.level1[each.value.parent_key].id,
    local.root_resource_id
  )
  path_part   = each.value.path_part

  depends_on = [aws_api_gateway_resource.level1, aws_api_gateway_resource.level2]
}

# Level 4 resources
resource "aws_api_gateway_resource" "level4" {
  for_each = local.level4_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = try(
    aws_api_gateway_resource.level3[each.value.parent_key].id,
    aws_api_gateway_resource.level2[each.value.parent_key].id,
    aws_api_gateway_resource.level1[each.value.parent_key].id,
    local.root_resource_id
  )
  path_part   = each.value.path_part

  depends_on = [aws_api_gateway_resource.level1, aws_api_gateway_resource.level2, aws_api_gateway_resource.level3]
}

# Level 5 resources
resource "aws_api_gateway_resource" "level5" {
  for_each = local.level5_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = try(
    aws_api_gateway_resource.level4[each.value.parent_key].id,
    aws_api_gateway_resource.level3[each.value.parent_key].id,
    aws_api_gateway_resource.level2[each.value.parent_key].id,
    aws_api_gateway_resource.level1[each.value.parent_key].id,
    local.root_resource_id
  )
  path_part   = each.value.path_part

  depends_on = [aws_api_gateway_resource.level1, aws_api_gateway_resource.level2, aws_api_gateway_resource.level3, aws_api_gateway_resource.level4]
}

# Level 6 resources
resource "aws_api_gateway_resource" "level6" {
  for_each = local.level6_resources

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = try(
    aws_api_gateway_resource.level5[each.value.parent_key].id,
    aws_api_gateway_resource.level4[each.value.parent_key].id,
    aws_api_gateway_resource.level3[each.value.parent_key].id,
    aws_api_gateway_resource.level2[each.value.parent_key].id,
    aws_api_gateway_resource.level1[each.value.parent_key].id,
    local.root_resource_id
  )
  path_part   = each.value.path_part

  depends_on = [aws_api_gateway_resource.level1, aws_api_gateway_resource.level2, aws_api_gateway_resource.level3, aws_api_gateway_resource.level4, aws_api_gateway_resource.level5]
}

# ==================== UNIFIED RESOURCE IDS MAP ====================

locals {
  all_resource_ids = merge(
    { "root" = local.root_resource_id },
    { for k, v in aws_api_gateway_resource.level1 : k => v.id },
    { for k, v in aws_api_gateway_resource.level2 : k => v.id },
    { for k, v in aws_api_gateway_resource.level3 : k => v.id },
    { for k, v in aws_api_gateway_resource.level4 : k => v.id },
    { for k, v in aws_api_gateway_resource.level5 : k => v.id },
    { for k, v in aws_api_gateway_resource.level6 : k => v.id }
  )
}

# ==================== METHODS ====================

resource "aws_api_gateway_method" "methods" {
  for_each = {
    for method in var.methods : method.key => method
  }

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = lookup(local.all_resource_ids, each.value.resource_key, local.root_resource_id)
  http_method   = each.value.http_method
  authorization = each.value.authorization
  authorizer_id = try(each.value.authorizer_id, null)
}

# ==================== INTEGRATIONS ====================

resource "aws_api_gateway_integration" "integrations" {
  for_each = {
    for method in var.methods : method.key => method if method.integration != null
  }

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = lookup(local.all_resource_ids, each.value.resource_key, local.root_resource_id)
  http_method = aws_api_gateway_method.methods[each.key].http_method

  type                    = each.value.integration.type
  uri                     = each.value.integration.uri
  integration_http_method = try(each.value.integration.integration_http_method, null)
  passthrough_behavior    = try(each.value.integration.passthrough_behavior, "WHEN_NO_MATCH") 
  content_handling        = try(each.value.integration.content_handling, null)
  request_templates       = try(each.value.integration.request_templates, null)
}

# ==================== DEPLOYMENT ====================

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.integrations
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id

  lifecycle {
    create_before_destroy = true
  }
}

# ==================== STAGE ====================

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.stage_name

  variables = var.stage_variables

  cache_cluster_enabled = false
  xray_tracing_enabled  = var.xray_tracing_enabled

  tags = var.tags
}

output "api_id" {
  description = "The ID of the REST API"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_arn" {
  description = "The ARN of the REST API"
  value       = aws_api_gateway_rest_api.api.arn
}

output "authorizer_id" {
  description = "ID of created authorizer"
  value       = aws_api_gateway_authorizer.authorizer.id
}

output "root_resource_id" {
  description = "The resource ID of the REST API's root"
  value       = aws_api_gateway_rest_api.api.root_resource_id
}

output "stage_name" {
  description = "The name of the stage"
  value       = aws_api_gateway_stage.stage.stage_name
}

output "invoke_url" {
  description = "The URL to invoke the API stage"
  value       = aws_api_gateway_stage.stage.invoke_url
}

output "execution_arn" {
  description = "The execution ARN part to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function"
  value       = aws_api_gateway_rest_api.api.execution_arn
}

## Terraform Configuration Guide for API Gateway

This document provides instructions for developers on how to add new routes (resources and methods) to the AWS API Gateway using the Terraform configuration managed by the `apigw` terraform module.

### Overview

The API Gateway configuration is defined within the `module "apigw {}"` block. It uses a `resources` list to define the URL path structure (e.g., `/user`, `/user/verify`) and a `methods` list to define the HTTP methods (e.g., `GET`, `POST`) and their backend integrations for each resource.

### Adding a New Route

To add a new route like `/user/new-endpoint`, follow these steps:

#### 1. Define the Resource(s)

First, you need to define the resource(s) that make up the path. Resources are added to the `resources` list within the module block.

*   **Resource Key:** A unique identifier for the resource within the Terraform configuration (e.g., `user-new-endpoint`).
*   **Parent Key:** The `key` of the parent resource. For top-level paths under `/`, use `parent_key = "root"`. For nested paths, use the `key` of the parent resource (e.g., `user` for `/user/new-endpoint`).
*   **Path Part:** The literal path segment (e.g., `new-endpoint`).

**Example:**

```hcl
module "abc_apigw" {
  source = "./path/to/apigw/module"
  # ... other module variables ...

  resources = [
    # ... existing resources ...
    
    # Add a new level 2 resource under 'user'
    { key = "user-new-endpoint", parent_key = "user", path_part = "new-endpoint" },

    # If you needed a level 3 resource like /user/new-endpoint/sub-action
    # { key = "user-new-endpoint-sub-action", parent_key = "user-new-endpoint", path_part = "sub-action" },
  ]

  # ... methods block ...
}
```

#### 2. Define the Method(s)

Next, define the HTTP methods for the new resource in the `methods` list. You typically need to define the actual method (`GET`, `POST`, etc.) and often an `OPTIONS` method for CORS.

*   **Key:** A unique identifier for the method within Terraform (e.g., `user-new-endpoint-get`, `user-new-endpoint-options`).
*   **Resource Key:** The `key` of the resource this method belongs to (e.g., `user-new-endpoint`).
*   **HTTP Method:** The HTTP verb (e.g., `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`).
*   **Authorization:** The type of authorization required (e.g., `NONE`, `AWS_IAM`, `COGNITO_USER_POOLS`).
*   **Authorizer ID:** Required if `authorization` is `COGNITO_USER_POOLS`. Use `module.abc_apigw.authorizer_id`.
*   **Integration:** Defines how the API Gateway connects to the backend.
    *   **Type:** The integration type (`HTTP_PROXY`, `AWS_PROXY`, `MOCK`).
    *   **URI:** The backend endpoint. For HTTP backends, use `https://$${stageVariables.apiDns}/...`. For Lambda, use the ARN format: `arn:aws:apigateway:region:lambda:path/2015-03-31/functions/arn:aws:lambda:region:account:function:function-name/invocations`. For `MOCK` integrations, this is often omitted or set to `""`.
    *   **Integration HTTP Method:** The HTTP method used for the integration request (e.g., `GET`, `POST`, `POST` for `AWS_PROXY`). For `OPTIONS` methods, this is often `OPTIONS` (for `HTTP_PROXY`) or `POST` (for `MOCK`).
    *   **Passthrough Behavior:** How the request body is passed to the backend (`WHEN_NO_MATCH`, `WHEN_NO_TEMPLATES`, `NEVER`).
    *   **Request Templates:** Optional. Used for `MOCK` or to transform requests for `HTTP_PROXY`/`AWS_PROXY` (e.g., for CORS preflight responses).

**Example:**

```hcl
module "abc_apigw" {
  source = "./path/to/apigw/module"
  # ... other module variables ...

  # ... resources block ...

  methods = [
    # ... existing methods ...

    # Define the GET method for /user/new-endpoint
    {
      key           = "user-new-endpoint-get"
      resource_key  = "user-new-endpoint"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS" # Or "AWS_IAM" or "NONE"
      authorizer_id = module.abc_apigw.authorizer_id # Required if authorization is COGNITO_USER_POOLS

      integration = {
        type                    = "HTTP_PROXY" # Or "AWS_PROXY" or "MOCK"
        uri                     = "https://$${stageVariables.apiDns}/user/new-endpoint" # The actual backend URL
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
        # content_handling = "CONVERT_TO_TEXT" # Optional
        # request_templates = { ... } # Optional
      }
    },

    # Define the OPTIONS method for CORS
    {
      key           = "user-new-endpoint-options"
      resource_key  = "user-new-endpoint"
      http_method   = "OPTIONS"
      authorization = "NONE" # OPTIONS methods are usually public

      integration = {
        type                    = "HTTP_PROXY" # Or "MOCK" for simple CORS
        uri                     = "https://$${stageVariables.apiDns}/user/new-endpoint" # URI of the resource it's for
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH" # Or "WHEN_NO_TEMPLATES" if using request_templates
        # Example using request_templates for simple CORS response:
        # request_templates = {
        #   "application/json" = jsonencode({ statusCode = 200 })
        # }
      }
    },

    # Define the POST method for /user/new-endpoint
    {
      key           = "user-new-endpoint-post"
      resource_key  = "user-new-endpoint"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id

      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/new-endpoint" # The actual backend URL
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

  ]
}
```

### Common Integration Types and URIs

*   **HTTP_PROXY:**
    *   **Use Case:** Connects to an HTTP endpoint (e.g., a load balancer, another API).
    *   **URI:** `https://$${stageVariables.apiDns}/path/to/endpoint` (using stage variables) or a full URL like `https://mybackend.example.com/api/v1/action`.
*   **AWS_PROXY:**
    *   **Use Case:** Connects directly to an AWS Lambda function.
    *   **URI:** `arn:aws:apigateway:region:lambda:path/2015-03-31/functions/arn:aws:lambda:region:account:function:my-function-name/invocations`
    *   **Integration HTTP Method:** Usually `POST`.
*   **MOCK:**
    *   **Use Case:** Returns a static response without calling a backend. Often used for `OPTIONS` responses in CORS or for testing.
    *   **URI:** Usually omitted or set to `""`.
    *   **Integration HTTP Method:** Often `POST`.
    *   **Passthrough Behavior:** Often `WHEN_NO_MATCH`.
    *   **Request Templates:** Typically used with `MOCK` to define the static response body and status code.

### Common Authorization Types

*   **NONE:** No authorization required.
*   **AWS_IAM:** Requires AWS IAM credentials.
*   **COGNITO_USER_POOLS:** Requires a valid JWT token from a Cognito User Pool.
    *   **Authorizer ID:** Must be set to `module.abc_apigw.authorizer_id`.

### Best Practices

*   **Consistency:** Follow the existing naming convention for `key` (e.g., `resource-name-httpmethod`).
*   **CORS:** Always consider adding an `OPTIONS` method for new endpoints that might be called from a browser.
*   **Testing:** After adding new routes, run `terraform plan` to verify the changes before applying them with `terraform apply`.
*   **State Management:** If you change the `key` or `parent_key` of an existing resource, you may need to use `terraform state mv` to move the existing resource state to the new configuration.

### Overview && examples of fields and parameters in `apigw` module
```hcl
module "example_apigw" {
  # Source path to the apigw module (required)
  # Points to the directory containing the module's main.tf, variables.tf, etc.
  source = "./path/to/your/apigw/module"

  # --- Required Variables ---
  # Name of the API Gateway resource in AWS (string, required)
  api_name = "my-api-gateway"

  # Name of the stage resource in AWS (string, required)
  stage_name = "staging"

  # Name of the Cognito Authorizer resource (string, required if using Cognito)
  authorizer_name = "my_cognito_authorizer"

  # --- Optional Variables with Defaults ---
  # Description for the API Gateway (string, optional, defaults to "")
  api_description = "My example API Gateway"

  # Stage variables passed to integrations (map of strings, optional, defaults to {})
  # Example: { apiDns = "api.example.com" }
  stage_variables = {}

  # Tags applied to API Gateway resources (map of strings, optional, defaults to {})
  # Example: { Environment = "Test", Team = "Backend" }
  tags = {}

  # Binary media types supported (list of strings, optional, defaults to ["*/*"])
  binary_media_types = ["item/png", "application/octet-stream"]

  # Minimum compression size in bytes (number, optional, defaults to null - disabled)
  minimum_compression_size = 1024

  # Type of the authorizer (string, optional, defaults to "REQUEST")
  # Commonly "COGNITO_USER_POOLS" when using Cognito.
  authorizer_type = "COGNITO_USER_POOLS"

  # ARNs for the authorizer (list of strings, optional, defaults to [])
  # Required if authorizer_type is "COGNITO_USER_POOLS".
  authorizer_provider_arns = ["arn:aws:cognito-idp:region:account:userpool/pool-id"]

  # Enable X-Ray tracing (bool, optional, defaults to false)
  xray_tracing_enabled = true

  # --- Configuration Blocks (Lists of Objects) ---
  # Defines the URL path structure (e.g., /user, /user/verify)
  # This is a list of objects, each defining a resource part.
  # 'key' (string, required): Unique identifier for the resource in Terraform.
  # 'parent_key' (string, required): Key of the parent resource. Use "root" for top-level paths.
  # 'path_part' (string, required): The literal path segment.
  resources = [
    { key = "root", parent_key = "root", path_part = "" }, # Implicit root resource
    { key = "user", parent_key = "root", path_part = "user" },
    { key = "verify", parent_key = "user", path_part = "verify" },
    { key = "admin", parent_key = "root", path_part = "admin" },
    { key = "any", parent_key = "admin", path_part = "any" },
  ]

  # Defines HTTP methods, authorization, and integrations for resources.
  # This is a list of objects, each defining a method and its integration.
  # 'key' (string, required): Unique identifier for the method in Terraform.
  # 'resource_key' (string, required): Key of the resource this method belongs to.
  # 'http_method' (string, required): The HTTP verb (GET, POST, OPTIONS, ANY, etc.).
  # 'authorization' (string, required): Authorization type (NONE, AWS_IAM, COGNITO_USER_POOLS, etc.).
  # 'authorizer_id' (string, optional): Reference to the authorizer resource (e.g., module.this_module_name.authorizer_id).
  # 'integration' (object, optional): Defines the backend integration. If null, no integration is created for this method.
  methods = [
    # Example: Root GET method with MOCK integration
    {
      key           = "root-get"
      resource_key  = "root" # Refers to the 'key' in the resources list
      http_method   = "GET"
      authorization = "NONE"
      # 'integration' block is optional. If omitted or set to null, no integration is created for this method.
      integration = {
        type = "MOCK" # Type of integration
        # uri (string, optional): Backend URI. Required for HTTP_PROXY, AWS_PROXY. Omitted for MOCK.
        # integration_http_method (string, optional): Method for the integration request (e.g., GET, POST, OPTIONS).
        # passthrough_behavior (string, optional): Defaults to "WHEN_NO_MATCH".
        # content_handling (string, optional): How to handle request/response bodies.
        # request_templates (map(string), optional): Templates for transforming requests/responses.
      }
    },
    # Example: Root OPTIONS method with HTTP_PROXY integration
    {
      key           = "root-options"
      resource_key  = "root"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user" # Example URI
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES" # Example behavior
        request_templates = {
          "application/json" = jsonencode({ statusCode = 200 })
        }
      }
    },
    # Example: /user GET method with COGNITO auth and HTTP_PROXY integration
    {
      key           = "user-get"
      resource_key  = "user"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      # authorizer_id is required if authorization is COGNITO_USER_POOLS
      authorizer_id = module.example_apigw.authorizer_id # Reference the authorizer from *this* module instance
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user-details"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    # Example: /user/verify POST method with COGNITO auth and AWS_PROXY integration (Lambda)
    {
      key           = "user-verify-post"
      resource_key  = "verify" # Refers to the 'verify' resource under 'user'
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.example_apigw.authorizer_id
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:region:lambda:path/2015-03-31/functions/arn:aws:lambda:region:account:function:my-lambda-function/invocations"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    # Example: /admin/any ANY method with AWS_PROXY integration (Lambda)
    {
      key           = "admin-any-any" # Key can be named anything, but convention helps
      resource_key  = "any" # Refers to the 'any' resource under 'admin'
      http_method   = "ANY"
      authorization = "AWS_IAM" # Example: AWS_IAM auth for admin
      # authorizer_id not needed for AWS_IAM
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:region:lambda:path/2015-03-31/functions/arn:aws:lambda:region:account:function:admin-lambda/invocations"
        integration_http_method = "POST" # Integration method for AWS_PROXY is usually POST
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
  ]
}
```

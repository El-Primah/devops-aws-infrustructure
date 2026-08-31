module "abc_apigw" {
  source = "../../../modules/apigw"

  api_name        = "abc-api-gateway-com"
  api_description = "Clone from abc-api-gateway"
  stage_name      = "production"
  binary_media_types = ["*/*"]

  # Athorizer
  authorizer_name             = "consumer_api_gateway_authorizer"
  authorizer_type             = "COGNITO_USER_POOLS"
  authorizer_provider_arns    = [aws_cognito_user_pool.abc_cognito.arn]
  xray_tracing_enabled        = false

  # Stage variables
  stage_variables = {
    apiDns = "api.comp.com"
  }

  tags = {}

  resources = [
    # Level 1
    { key = "item", parent_key = "root", path_part = "item" },
    { key = "lambda", parent_key = "root", path_part = "lambda" },
    { key = "que_app", parent_key = "root", path_part = "que_app" },
    { key = "send-result-to-email", parent_key = "root", path_part = "send-result-to-email" },
    { key = "v1", parent_key = "root", path_part = "v1" },
    { key = "webhooks", parent_key = "root", path_part = "webhooks" },
    { key = "case", parent_key = "root", path_part = "case" },
    { key = "analytics", parent_key = "root", path_part = "analytics" },
    { key = "get-result-pdf", parent_key = "root", path_part = "get-result-pdf" },
    { key = "download-que_app-result-pdf", parent_key = "root", path_part = "download-que_app-result-pdf" },
    { key = "user", parent_key = "root", path_part = "user" },
    { key = "verify-recaptcha", parent_key = "root", path_part = "verify-recaptcha" },
    { key = "accept-tos", parent_key = "root", path_part = "accept-tos" },
    { key = "providers", parent_key = "root", path_part = "providers" },
    { key = "articles", parent_key = "root", path_part = "articles" },
    { key = "get-init-analysis", parent_key = "root", path_part = "get-init-analysis" },
    { key = "get-item-result", parent_key = "root", path_part = "get-item-result" },
    { key = "contact-us", parent_key = "root", path_part = "contact-us" },
    { key = "get-item-details", parent_key = "root", path_part = "get-item-details" },
    { key = "get-case-item", parent_key = "root", path_part = "get-case-item" },
    { key = "consts", parent_key = "root", path_part = "consts" },
    { key = "opt-ins-options", parent_key = "root", path_part = "opt-ins-options" },
    { key = "feedback", parent_key = "root", path_part = "feedback" },
    { key = "init", parent_key = "root", path_part = "init" },
    { key = "check-access-code", parent_key = "root", path_part = "check-access-code" },
    { key = "admin", parent_key = "root", path_part = "admin" },

    # Level 2
    { key = "user-verify", parent_key = "user", path_part = "verify" },
    { key = "user-pusher-visitor-auth", parent_key = "user", path_part = "pusher-visitor-auth" },
    { key = "user-pusher-auth", parent_key = "user", path_part = "pusher-auth" },
    { key = "user-phone", parent_key = "user", path_part = "phone" },
    { key = "user-forms", parent_key = "user", path_part = "forms" },
    { key = "user-contact", parent_key = "user", path_part = "contact" },
    { key = "item-cropped-chunked-upload-done", parent_key = "item", path_part = "cropped-chunked-upload-done" },
    { key = "item-detail", parent_key = "item", path_part = "detail" },
    { key = "item-result", parent_key = "item", path_part = "result" },
    { key = "item-get-all", parent_key = "item", path_part = "get-all" },
    { key = "item-re-validate", parent_key = "item", path_part = "re-validate" },
    { key = "item-validation-update", parent_key = "item", path_part = "validation-update" },
    { key = "item-save", parent_key = "item", path_part = "save" },
    { key = "item-upload-new-item", parent_key = "item", path_part = "upload-new-item" },
    { key = "item-result-breakdown", parent_key = "item", path_part = "result-breakdown" },
    { key = "que_app-result", parent_key = "que_app", path_part = "result" },
    { key = "que_app-update", parent_key = "que_app", path_part = "update" },
    { key = "que_app-partial", parent_key = "que_app", path_part = "partial" },
    { key = "que_app-status", parent_key = "que_app", path_part = "status" },
    { key = "que_app-assessment-request-token", parent_key = "que_app", path_part = "assessment-request-token" },
    { key = "que_app-create-mock", parent_key = "que_app", path_part = "create-mock" },
    { key = "que_app-form", parent_key = "que_app", path_part = "form" },
    { key = "case-appointments", parent_key = "case", path_part = "appointments" },
    { key = "case-syndrome", parent_key = "case", path_part = "syndrome" },
    { key = "case-dscore", parent_key = "case", path_part = "dscore" },
    { key = "case-zipcode", parent_key = "case", path_part = "zipcode" },
    { key = "webhooks-typeform", parent_key = "webhooks", path_part = "typeform" },
    { key = "analytics-send", parent_key = "analytics", path_part = "send" },
    { key = "providers-leads", parent_key = "providers", path_part = "leads" },
    { key = "providers-premium-listing", parent_key = "providers", path_part = "premium-listing" },
    { key = "providers-category", parent_key = "providers", path_part = "category" },
    { key = "providers-listing", parent_key = "providers", path_part = "listing" },
    { key = "providers-details", parent_key = "providers", path_part = "details" },
    { key = "providers-display-get-help", parent_key = "providers", path_part = "display-get-help" },
    { key = "providers-genetic-test-form", parent_key = "providers", path_part = "genetic-test-form" },
    { key = "providers-connect", parent_key = "providers", path_part = "connect" },
    { key = "providers-insurance", parent_key = "providers", path_part = "insurance" },
    { key = "providers-zipcode", parent_key = "providers", path_part = "zipcode" },
    { key = "consts-user-consts", parent_key = "consts", path_part = "user-consts" },
    { key = "admin-templates", parent_key = "admin", path_part = "templates" },
    { key = "admin-campaigns", parent_key = "admin", path_part = "campaigns" },
    { key = "lambda-cases", parent_key = "lambda", path_part = "cases" },
    { key = "v1-que_app", parent_key = "v1", path_part = "que_app" },

    # Level 3
    { key = "user-phone-send-code", parent_key = "user-phone", path_part = "send-code" },
    { key = "user-phone-verify", parent_key = "user-phone", path_part = "verify" },
    { key = "providers-category-listing", parent_key = "providers-category", path_part = "listing" },
    { key = "providers-leads-fields", parent_key = "providers-leads", path_part = "fields" },
    { key = "providers-leads-summary", parent_key = "providers-leads", path_part = "summary" },
    { key = "que_app-form-start-submission", parent_key = "que_app-form", path_part = "start-submission" },
    { key = "que_app-form-collect-answers", parent_key = "que_app-form", path_part = "collect-answers" },
    { key = "v1-que_app-update", parent_key = "v1-que_app", path_part = "update" },

  ]

  methods = [
    # Root resource
    {
      key           = "root-get"
      resource_key  = "root"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type = "MOCK"
        # passthrough_behavior = "WHEN_NO_MATCH"
      }
    },

    {
      key           = "root-options"
      resource_key  = "root"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/all"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item/detail
    {
      key           = "item-detail-get"
      resource_key  = "item-detail"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/detail"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-detail-options"
      resource_key  = "item-detail"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/detail"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app/result
    {
      key           = "que_app-result-get"
      resource_key  = "que_app-result"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-result-delete"
      resource_key  = "que_app-result"
      http_method   = "DELETE"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/result"
        integration_http_method = "DELETE"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-result-options"
      resource_key  = "que_app-result"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/result"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /send-result-to-email
    {
      key           = "send-result-to-email-get"
      resource_key  = "send-result-to-email"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/email-result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "send-result-to-email-options"
      resource_key  = "send-result-to-email"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/email-result"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /webhooks/typeform
    {
      key           = "webhooks-typeform-post"
      resource_key  = "webhooks-typeform"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/webhooks/typeform"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "webhooks-typeform-options"
      resource_key  = "webhooks-typeform"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/webhooks/typeform"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
          "application/json" = jsonencode({ statusCode = 200 })
        }
      }
    },

    # /case/appointments
    {
      key           = "case-appointments-get"
      resource_key  = "case-appointments"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/appointments"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-appointments-post"
      resource_key  = "case-appointments"
      http_method   = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/appointments"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-appointments-options"
      resource_key  = "case-appointments"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/appointments"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /providers/leads
    {
      key           = "providers-leads-post"
      resource_key  = "providers-leads"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-leads-options"
      resource_key  = "providers-leads"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /accept-tos
    {
      key           = "accept-tos-post"
      resource_key  = "accept-tos"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/accept-tos"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "accept-tos-options"
      resource_key  = "accept-tos"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/accept-tos"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user/phone/send-code
    {
      key           = "user-phone-send-code-post"
      resource_key  = "user-phone-send-code"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/phone/send-code"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-phone-send-code-options"
      resource_key  = "user-phone-send-code"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/phone/send-code"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /verify-recaptcha
    {
      key           = "verify-recaptcha-post"
      resource_key  = "verify-recaptcha"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/captcha/verify"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "verify-recaptcha-options"
      resource_key  = "verify-recaptcha"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/captcha/verify"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app
    {
      key           = "que_app-post"
      resource_key  = "que_app"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/submit"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-options"
      resource_key  = "que_app"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/submit"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /get-result-pdf
    {
      key           = "get-result-pdf-get"
      resource_key  = "get-result-pdf"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/download-result-pdf"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "get-result-pdf-options"
      resource_key  = "get-result-pdf"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/download-result-pdf"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item
    {
      key           = "item-get"
      resource_key  = "item"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-delete"
      resource_key  = "item"
      http_method   = "DELETE"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item"
        integration_http_method = "DELETE"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-options"
      resource_key  = "item"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /case
    {
      key           = "case-get"
      resource_key  = "case"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/all"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-post"
      resource_key  = "case"
      http_method   = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/upload-item"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-options"
      resource_key  = "case"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/all"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /webhooks
    {
      key           = "webhooks-options"
      resource_key  = "webhooks"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/webhooks/typeform"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /user/forms
    {
      key           = "user-forms-get"
      resource_key  = "user-forms"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/forms"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-forms-options"
      resource_key  = "user-forms"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/forms"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /download-que_app-result-pdf
    {
      key           = "download-que_app-result-pdf-get"
      resource_key  = "download-que_app-result-pdf"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/download-que_app-result-pdf"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "download-que_app-result-pdf-options"
      resource_key  = "download-que_app-result-pdf"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/download-que_app-result-pdf"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /lambda/cases
    {
      key           = "lambda-cases-any"
      resource_key  = "lambda-cases"
      http_method   = "ANY"
      authorization = "NONE"
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:939393939393:function:bm-get-cases/invocations"
        integration_http_method = "POST" 
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    # lambda-cases-options
    {
      key           = "lambda-cases-options"
      resource_key  = "lambda-cases"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:939393939393:function:bm-get-cases/invocations"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /analytics
    {
      key           = "analytics-options"
      resource_key  = "analytics"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/analytics/send"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app/update
    {
      key           = "que_app-update-post"
      resource_key  = "que_app-update"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/update"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-update-options"
      resource_key  = "que_app-update"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/update"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item/result-breakdown
    {
      key           = "item-result-breakdown-get"
      resource_key  = "item-result-breakdown"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/result-breakdown"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-result-breakdown-options"
      resource_key  = "item-result-breakdown"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/result-breakdown"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /providers/premium-listing
    {
      key           = "providers-premium-listing-get"
      resource_key  = "providers-premium-listing"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/premium-listing"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-premium-listing-options"
      resource_key  = "providers-premium-listing"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/premium-listing"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /articles
    {
      key           = "articles-get"
      resource_key  = "articles"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/articles"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "articles-options"
      resource_key  = "articles"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/articles"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user/contact
    {
      key           = "user-contact-post"
      resource_key  = "user-contact"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/contact"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-contact-options"
      resource_key  = "user-contact"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/contact"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/category/listing
    {
      key           = "providers-category-listing-get"
      resource_key  = "providers-category-listing"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/category/listing"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-category-listing-options"
      resource_key  = "providers-category-listing"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/category/listing"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user/verify
    {
      key           = "user-verify-post"
      resource_key  = "user-verify"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/phone/verify"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-verify-options"
      resource_key  = "user-verify"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/phone/verify"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /case/syndrome
    {
      key           = "case-syndrome-get"
      resource_key  = "case-syndrome"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/suggested-syndrome"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-syndrome-options"
      resource_key  = "case-syndrome"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/suggested-syndrome"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /admin/templates
    {
      key           = "admin-templates-any"
      resource_key  = "admin-templates"
      http_method   = "ANY"
      authorization = "NONE"
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:939393939393:function:notification-templates/invocations"
        integration_http_method = "POST" 
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # admin-templates-options
    {
      key           = "admin-templates-options"
      resource_key  = "admin-templates"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:939393939393:function:notification-templates/invocations"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/listing
    {
      key           = "providers-listing-get"
      resource_key  = "providers-listing"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/listing"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-listing-options"
      resource_key  = "providers-listing"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/listing"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item/result
    {
      key           = "item-result-get"
      resource_key  = "item-result"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-result-options"
      resource_key  = "item-result"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/result"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/display-get-help
    {
      key           = "providers-display-get-help-get"
      resource_key  = "providers-display-get-help"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/display-get-help"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-display-get-help-options"
      resource_key  = "providers-display-get-help"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/display-get-help"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app/form/start-submission
    {
      key           = "que_app-form-start-submission-post"
      resource_key  = "que_app-form-start-submission"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form/start-submission"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-form-start-submission-options"
      resource_key  = "que_app-form-start-submission"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form/start-submission"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
            request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /item/get-all
    {
      key           = "item-get-all-get"
      resource_key  = "item-get-all"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/get-all"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-get-all-options"
      resource_key  = "item-get-all"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/get-all"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/leads/summary
    {
      key           = "providers-leads-summary-get"
      resource_key  = "providers-leads-summary"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads/summary"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-leads-summary-options"
      resource_key  = "providers-leads-summary"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads/summary"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /check-access-code
    {
      key           = "check-access-code-get"
      resource_key  = "check-access-code"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/check-access-code"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "check-access-code-options"
      resource_key  = "check-access-code"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/check-access-code"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app/partial
    {
      key           = "que_app-partial-get"
      resource_key  = "que_app-partial"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/partial"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-partial-options"
      resource_key  = "que_app-partial"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/partial"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user
    {
      key           = "user-get"
      resource_key  = "user"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user-details"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-post"
      resource_key  = "user"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/register"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-options"
      resource_key  = "user"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/register"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /get-init-analysis
    {
      key           = "get-init-analysis-get"
      resource_key  = "get-init-analysis"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-init-analysis"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "get-init-analysis-options"
      resource_key  = "get-init-analysis"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-init-analysis"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /get-item-result
    {
      key           = "get-item-result-get"
      resource_key  = "get-item-result"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item-result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "get-item-result-options"
      resource_key  = "get-item-result"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item-result"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item/validation-update
    {
      key           = "item-validation-update-post"
      resource_key  = "item-validation-update"
      http_method   = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/validation-update"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-validation-update-options"
      resource_key  = "item-validation-update"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/validation-update"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user/phone/verify
    {
      key           = "user-phone-verify-post"
      resource_key  = "user-phone-verify"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/phone/verify"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-phone-verify-options"
      resource_key  = "user-phone-verify"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user/phone/verify"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /item/re-validate
    {
      key           = "item-re-validate-post"
      resource_key  = "item-re-validate"
      http_method   = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/re-validate"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-re-validate-options"
      resource_key  = "item-re-validate"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/re-validate"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /providers/details
    {
      key           = "providers-details-get"
      resource_key  = "providers-details"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/details"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-details-options"
      resource_key  = "providers-details"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/details"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item/save
    {
      key           = "item-save-post"
      resource_key  = "item-save"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/save"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-save-options"
      resource_key  = "item-save"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/save"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /get-item-details
    {
      key           = "get-item-details-get"
      resource_key  = "get-item-details"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-item-details"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "get-item-details-options"
      resource_key  = "get-item-details"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-item-details"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /contact-us
    {
      key           = "contact-us-post"
      resource_key  = "contact-us"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/contact-us"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "contact-us-options"
      resource_key  = "contact-us"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/contact-us"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user/pusher-visitor-auth
    {
      key           = "user-pusher-visitor-auth-post"
      resource_key  = "user-pusher-visitor-auth"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/pusher-visitor-auth"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-pusher-visitor-auth-options"
      resource_key  = "user-pusher-visitor-auth"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/pusher-visitor-auth"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app/form
    {
      key           = "que_app-form-get"
      resource_key  = "que_app-form"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-form-options"
      resource_key  = "que_app-form"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /get-case-item
    {
      key           = "get-case-item-get"
      resource_key  = "get-case-item"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-case-item"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "get-case-item-options"
      resource_key  = "get-case-item"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-case-item"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /consts/user-consts
    {
      key           = "consts-user-consts-get"
      resource_key  = "consts-user-consts"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consts/user-consts"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "consts-user-consts-options"
      resource_key  = "consts-user-consts"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consts/user-consts"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /providers/insurance
    {
      key           = "providers-insurance-get"
      resource_key  = "providers-insurance"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/insurance"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-insurance-options"
      resource_key  = "providers-insurance"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/insurance"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/zipcode
    {
      key           = "providers-zipcode-get"
      resource_key  = "providers-zipcode"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/zipcode"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-zipcode-options"
      resource_key  = "providers-zipcode"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/zipcode"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /opt-ins-options
    {
      key           = "opt-ins-options-post"
      resource_key  = "opt-ins-options"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/opt-ins-options"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "opt-ins-options-options"
      resource_key  = "opt-ins-options"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/opt-ins-options"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /case/dscore
    {
      key           = "case-dscore-get"
      resource_key  = "case-dscore"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/d-score"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-dscore-options"
      resource_key  = "case-dscore"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/d-score"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /user/pusher-auth
    {
      key           = "user-pusher-auth-post"
      resource_key  = "user-pusher-auth"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/pusher-auth"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "user-pusher-auth-options"
      resource_key  = "user-pusher-auth"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/pusher-auth"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /consts
    {
      key           = "consts-get"
      resource_key  = "consts"
      http_method   = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consts"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "consts-post"
      resource_key  = "consts"
      http_method   = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consts"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "consts-options"
      resource_key  = "consts"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consts"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/genetic-test-form
    {
      key           = "providers-genetic-test-form-get"
      resource_key  = "providers-genetic-test-form"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/genetic-test-form"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-genetic-test-form-post"
      resource_key  = "providers-genetic-test-form"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/genetic-test-form"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-genetic-test-form-options"
      resource_key  = "providers-genetic-test-form"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/genetic-test-form"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }

      }
    },

    # /que_app/status
    {
      key           = "que_app-status-get"
      resource_key  = "que_app-status"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/status"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-status-options"
      resource_key  = "que_app-status"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/status"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers
    {
      key           = "providers-options"
      resource_key  = "providers"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /providers/connect
    {
      key           = "providers-connect-post"
      resource_key  = "providers-connect"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/connect"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-connect-options"
      resource_key  = "providers-connect"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/connect"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /item/upload-new-item
    {
      key           = "item-upload-new-item-post"
      resource_key  = "item-upload-new-item"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/upload-new-item"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "item-upload-new-item-options"
      resource_key  = "item-upload-new-item"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/upload-new-item"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }

      }
    },

    # /case/zipcode
    {
      key           = "case-zipcode-post"
      resource_key  = "case-zipcode"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/zipcode"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "case-zipcode-options"
      resource_key  = "case-zipcode"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/zipcode"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /que_app/assessment-request-token
    {
      key           = "que_app-assessment-request-token-get"
      resource_key  = "que_app-assessment-request-token"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/assessment-request-token"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-assessment-request-token-options"
      resource_key  = "que_app-assessment-request-token"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/assessment-request-token"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /feedback
    {
      key           = "feedback-get"
      resource_key  = "feedback"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/feedback"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "feedback-post"
      resource_key  = "feedback"
      http_method   = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/feedback"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "feedback-options"
      resource_key  = "feedback"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/feedback"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /providers/leads/fields
    {
      key           = "providers-leads-fields-get"
      resource_key  = "providers-leads-fields"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads/fields"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "providers-leads-fields-options"
      resource_key  = "providers-leads-fields"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads/fields"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /analytics/send
    {
      key           = "analytics-send-post"
      resource_key  = "analytics-send"
      http_method   = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/analytics/send"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "analytics-send-options"
      resource_key  = "analytics-send"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/analytics/send"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /admin/campaigns
    {
      key           = "admin-campaigns-any"
      resource_key  = "admin-campaigns"
      http_method   = "ANY"
      authorization = "NONE"
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:939393939393:function:notification-campaigns/invocations"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    # admin-campaigns-options
    {
      key           = "admin-campaigns-options"
      resource_key  = "admin-campaigns"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "AWS_PROXY"
        uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:939393939393:function:notification-campaigns/invocations"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /v1/que_app/update
    {
      key           = "v1-que_app-update-post"
      resource_key  = "v1-que_app-update"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/v1/que_app/update"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "v1-que_app-update-options"
      resource_key  = "v1-que_app-update"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/v1/que_app/update"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /que_app/form/collect-answers
    {
      key           = "que_app-form-collect-answers-post"
      resource_key  = "que_app-form-collect-answers"
      http_method   = "POST"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form/collect-answers"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-form-collect-answers-options"
      resource_key  = "que_app-form-collect-answers"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form/collect-answers"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_TEMPLATES"
        request_templates       = {
            "application/json" = jsonencode(
                {
                    statusCode = 200
                }
            )
        }
      }
    },

    # /que_app/create-mock
    {
      key           = "que_app-create-mock-get"
      resource_key  = "que_app-create-mock"
      http_method   = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.abc_apigw.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/create-mock"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "que_app-create-mock-options"
      resource_key  = "que_app-create-mock"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/create-mock"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # /init
    {
      key           = "init-get"
      resource_key  = "init"
      http_method   = "GET"
      authorization = "NONE" 
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/init"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key           = "init-options"
      resource_key  = "init"
      http_method   = "OPTIONS"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/init"
        integration_http_method = "OPTIONS"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

  ]
}


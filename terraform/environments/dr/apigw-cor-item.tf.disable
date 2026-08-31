module "apigw_cor_item" {
  source = "../../modules/apigw"
  
  api_name        = var.apigw_cor_item_name
  api_description = "Clone from cor_item-api-gateway"
  stage_name      = var.apigw_cor_item_stage_name
  region          = data.aws_region.current.name
  
  stage_variables = {
    apiDns = var.stage_var_api_dns
  }
  
  authorizer_name          = var.cor_item_com_api_auth_name
  authorizer_type          = "COGNITO_USER_POOLS"
  authorizer_provider_arns = [aws_cognito_user_pool.cor_item_cognito.arn]
  
  xray_tracing_enabled = false
  
  resources = [
    # =============== LEVEL 1 RESOURCES ===============
    {
      key       = "user"
      parent_key = "root"
      path_part = "user"
    },
    {
      key       = "providers"
      parent_key = "root"
      path_part = "providers"
    },
    {
      key       = "item"
      parent_key = "root"
      path_part = "item"
    },
    {
      key       = "que_app"
      parent_key = "root"
      path_part = "que_app"
    },
    {
      key       = "case"
      parent_key = "root"
      path_part = "case"
    },
    {
      key       = "consts"
      parent_key = "root"
      path_part = "consts"
    },
    {
      key       = "analytics"
      parent_key = "root"
      path_part = "analytics"
    },
    {
      key       = "get-init-analysis"
      parent_key = "root"
      path_part = "get-init-analysis"
    },
    {
      key       = "download-que_app-result-pdf"
      parent_key = "root"
      path_part = "download-que_app-result-pdf"
    },
    {
      key       = "accept-tos"
      parent_key = "root"
      path_part = "accept-tos"
    },
    {
      key       = "check-access-code"
      parent_key = "root"
      path_part = "check-access-code"
    },
    {
      key       = "init"
      parent_key = "root"
      path_part = "init"
    },
    {
      key       = "articles"
      parent_key = "root"
      path_part = "articles"
    },
    {
      key       = "contact-us"
      parent_key = "root"
      path_part = "contact-us"
    },
    {
      key       = "opt-ins-options"
      parent_key = "root"
      path_part = "opt-ins-options"
    },
    {
      key       = "verify-recaptcha"
      parent_key = "root"
      path_part = "verify-recaptcha"
    },
    {
      key       = "get-result-pdf"
      parent_key = "root"
      path_part = "get-result-pdf"
    },
    {
      key       = "send-result-to-email"
      parent_key = "root"
      path_part = "send-result-to-email"
    },
    {
      key       = "consent"
      parent_key = "root"
      path_part = "consent"
    },

    # =============== LEVEL 2 RESOURCES ===============
    {
      key       = "user_verify-token"
      parent_key = "user"
      path_part = "verify-token"
    },
    {
      key       = "user_pusher-auth"
      parent_key = "user"
      path_part = "pusher-auth"
    },
    {
      key       = "user_pusher-visitor-auth"
      parent_key = "user"
      path_part = "pusher-visitor-auth"
    },
    {
      key       = "providers_specialties"
      parent_key = "providers"
      path_part = "specialties"
    },
    {
      key       = "providers_leads"
      parent_key = "providers"
      path_part = "leads"
    },
    {
      key       = "providers_is-connected"
      parent_key = "providers"
      path_part = "is-connected"
    },
    {
      key       = "providers_category"
      parent_key = "providers"
      path_part = "category"
    },
    {
      key       = "providers_insurance"
      parent_key = "providers"
      path_part = "insurance"
    },
    {
      key       = "providers_premium-listing"
      parent_key = "providers"
      path_part = "premium-listing"
    },
    {
      key       = "providers_details"
      parent_key = "providers"
      path_part = "details"
    },
    {
      key       = "providers_listing"
      parent_key = "providers"
      path_part = "listing"
    },
    {
      key       = "providers_zipcode"
      parent_key = "providers"
      path_part = "zipcode"
    },
    {
      key       = "providers_display-get-help"
      parent_key = "providers"
      path_part = "display-get-help"
    },
    {
      key       = "providers_connect"
      parent_key = "providers"
      path_part = "connect"
    },
    {
      key       = "item_get-all"
      parent_key = "item"
      path_part = "get-all"
    },
    {
      key       = "item_detail"
      parent_key = "item"
      path_part = "detail"
    },
    {
      key       = "item_result"
      parent_key = "item"
      path_part = "result"
    },
    {
      key       = "item_save"
      parent_key = "item"
      path_part = "save"
    },
    {
      key       = "item_validation-update"
      parent_key = "item"
      path_part = "validation-update"
    },
    {
      key       = "item_re-validate"
      parent_key = "item"
      path_part = "re-validate"
    },
    {
      key       = "item_result-breakdown"
      parent_key = "item"
      path_part = "result-breakdown"
    },
    {
      key       = "item_upload-new-item"
      parent_key = "item"
      path_part = "upload-new-item"
    },
    {
      key       = "que_app_create-mock"
      parent_key = "que_app"
      path_part = "create-mock"
    },
    {
      key       = "que_app_form"
      parent_key = "que_app"
      path_part = "form"
    },
    {
      key       = "que_app_assessment-request-token"
      parent_key = "que_app"
      path_part = "assessment-request-token"
    },
    {
      key       = "que_app_result"
      parent_key = "que_app"
      path_part = "result"
    },
    {
      key       = "que_app_partial"
      parent_key = "que_app"
      path_part = "partial"
    },
    {
      key       = "que_app_status"
      parent_key = "que_app"
      path_part = "status"
    },
    {
      key       = "que_app_update"
      parent_key = "que_app"
      path_part = "update"
    },
    {
      key       = "case_dscore"
      parent_key = "case"
      path_part = "dscore"
    },
    {
      key       = "case_zipcode"
      parent_key = "case"
      path_part = "zipcode"
    },
    {
      key       = "analytics_send"
      parent_key = "analytics"
      path_part = "send"
    },

    # =============== LEVEL 3 RESOURCES ===============
    {
      key       = "providers_leads_fields"
      parent_key = "providers_leads"
      path_part = "fields"
    },
    {
      key       = "providers_leads_summary"
      parent_key = "providers_leads"
      path_part = "summary"
    },
    {
      key       = "providers_category_listing"
      parent_key = "providers_category"
      path_part = "listing"
    },
    {
      key       = "que_app_form_start-submission"
      parent_key = "que_app_form"
      path_part = "start-submission"
    },
    {
      key       = "que_app_form_collect-answers"
      parent_key = "que_app_form"
      path_part = "collect-answers"
    }
  ]

  methods = [
    # =============== ROOT METHOD ===============
    {
      key          = "root_get"
      resource_key = "root"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                 = "MOCK"
        uri                  = ""
        passthrough_behavior = "WHEN_NO_MATCH"
      }
    },

    # =============== USER METHODS ===============
    {
      key          = "user_get"
      resource_key = "user"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/user-details"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "user_post"
      resource_key = "user"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/register"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "user_verify-token_get"
      resource_key = "user_verify-token"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/verify-token"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "user_pusher-auth_post"
      resource_key = "user_pusher-auth"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/pusher-auth"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "user_pusher-visitor-auth_post"
      resource_key = "user_pusher-visitor-auth"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/pusher-visitor-auth"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== PROVIDERS METHODS ===============
    {
      key          = "providers_specialties_get"
      resource_key = "providers_specialties"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/specialties"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_leads_post"
      resource_key = "providers_leads"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_is-connected_get"
      resource_key = "providers_is-connected"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/is-connected"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_insurance_get"
      resource_key = "providers_insurance"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/insurance"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_premium-listing_get"
      resource_key = "providers_premium-listing"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/premium-listing"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_details_get"
      resource_key = "providers_details"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/details"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_listing_get"
      resource_key = "providers_listing"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/listing"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_zipcode_get"
      resource_key = "providers_zipcode"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/zipcode"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_display-get-help_get"
      resource_key = "providers_display-get-help"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/display-get-help"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_connect_post"
      resource_key = "providers_connect"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/connect"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_leads_fields_get"
      resource_key = "providers_leads_fields"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads/fields"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_leads_summary_get"
      resource_key = "providers_leads_summary"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/leads/summary"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "providers_category_listing_get"
      resource_key = "providers_category_listing"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/providers/category/listing"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== ITEM METHODS ===============
    {
      key          = "item_get"
      resource_key = "item"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_delete"
      resource_key = "item"
      http_method  = "DELETE"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item"
        integration_http_method = "DELETE"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_get-all_get"
      resource_key = "item_get-all"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/get-all"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_detail_get"
      resource_key = "item_detail"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/detail"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_result_get"
      resource_key = "item_result"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_save_post"
      resource_key = "item_save"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/save"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_validation-update_post"
      resource_key = "item_validation-update"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/validation-update"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_re-validate_post"
      resource_key = "item_re-validate"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/re-validate"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_result-breakdown_get"
      resource_key = "item_result-breakdown"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/result-breakdown"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "item_upload-new-item_post"
      resource_key = "item_upload-new-item"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/item/upload-new-item"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== que_app METHODS ===============
    {
      key          = "que_app_post"
      resource_key = "que_app"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/submit"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_create-mock_get"
      resource_key = "que_app_create-mock"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/create-mock"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_form_get"
      resource_key = "que_app_form"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_assessment-request-token_get"
      resource_key = "que_app_assessment-request-token"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/assessment-request-token"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_result_get"
      resource_key = "que_app_result"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_result_delete"
      resource_key = "que_app_result"
      http_method  = "DELETE"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/result"
        integration_http_method = "DELETE"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_partial_get"
      resource_key = "que_app_partial"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/partial"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_status_get"
      resource_key = "que_app_status"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/status"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_update_post"
      resource_key = "que_app_update"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/update"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_form_start-submission_post"
      resource_key = "que_app_form_start-submission"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form/start-submission"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "que_app_form_collect-answers_post"
      resource_key = "que_app_form_collect-answers"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/que_app/form/collect-answers"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== CASE METHODS ===============
    {
      key          = "case_get"
      resource_key = "case"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/case/all"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "case_post"
      resource_key = "case"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/upload-item"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "case_dscore_get"
      resource_key = "case_dscore"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/d-score"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "case_zipcode_get"
      resource_key = "case_zipcode"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/zipcode"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== consts METHODS ===============
    {
      key          = "consts_get"
      resource_key = "consts"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consts"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "consent_post"
      resource_key = "consent"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/consent"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== ANALYTICS METHODS ===============
    {
      key          = "analytics_send_post"
      resource_key = "analytics_send"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/analytics/send"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },

    # =============== OTHER METHODS ===============
    {
      key          = "get-init-analysis_get"
      resource_key = "get-init-analysis"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/get-init-analysis"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "download-que_app-result-pdf_get"
      resource_key = "download-que_app-result-pdf"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/download-que_app-result-pdf"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "accept-tos_post"
      resource_key = "accept-tos"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/accept-tos"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "check-access-code_get"
      resource_key = "check-access-code"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/check-access-code"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "init_get"
      resource_key = "init"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/init"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "articles_get"
      resource_key = "articles"
      http_method  = "GET"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/articles"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "contact-us_post"
      resource_key = "contact-us"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/contact-us"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "opt-ins-options_post"
      resource_key = "opt-ins-options"
      http_method  = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/opt-ins-options"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "verify-recaptcha_post"
      resource_key = "verify-recaptcha"
      http_method  = "POST"
      authorization = "NONE"
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/captcha/verify"
        integration_http_method = "POST"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "get-result-pdf_get"
      resource_key = "get-result-pdf"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/download-result-pdf"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    },
    {
      key          = "send-result-to-email_get"
      resource_key = "send-result-to-email"
      http_method  = "GET"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = module.apigw_cor_item.authorizer_id
      integration = {
        type                    = "HTTP_PROXY"
        uri                     = "https://$${stageVariables.apiDns}/email-result"
        integration_http_method = "GET"
        passthrough_behavior    = "WHEN_NO_MATCH"
      }
    }
  ]
}

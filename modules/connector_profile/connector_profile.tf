resource "aws_appflow_connector_profile" "connector_profile" {
  name            = var.connector_profile_name
  connection_mode = var.connector_profile_connection_mode
  connector_type  = var.connector_profile_connector_type
  connector_label = var.connector_profile_connector_label
  kms_arn         = var.connector_profile_kms_arn
  connector_profile_config {
    connector_profile_credentials {
      dynamic "custom_connector" {
        for_each = var.connector_profile_credentials.custom_connector != null ? [var.connector_profile_credentials.custom_connector] : []
        content {
          authentication_type = custom_connector.value.authentication_type
          dynamic "api_key" {
            for_each = custom_connector.value.api_key != null ? [custom_connector.value.api_key] : []
            content {
              api_key        = api_key.value.api_key
              api_secret_key = api_key.value.api_secret_key
            }
          }
          dynamic "basic" {
            for_each = custom_connector.value.basic != null ? [custom_connector.value.basic] : []
            content {
              username = basic.value.username
              password = basic.value.password
            }
          }
          dynamic "custom" {
            for_each = custom_connector.value.custom != null ? [custom_connector.value.custom] : []
            content {
              custom_authentication_type = custom.value.custom_authentication_type
              credentials_map            = custom.value.credentials_map
            }
          }
          dynamic "oauth2" {
            for_each = custom_connector.value.oauth2 != null ? [custom_connector.value.oauth2] : []
            content {
              access_token  = oauth2.value.access_token
              client_id     = oauth2.value.client_id
              client_secret = oauth2.value.client_secret
              refresh_token = oauth2.value.refresh_token
              dynamic "oauth_request" {
                for_each = oauth2.value.oauth_request != null ? [oauth2.value.oauth_request] : []
                content {
                  auth_code    = oauth_request.value.auth_code
                  redirect_uri = oauth_request.value.redirect_uri
                }
              }
            }
          }
        }
      }
      dynamic "redshift" {
        for_each = var.connector_profile_credentials.redshift != null ? [var.connector_profile_credentials.redshift] : []
        content {
          username = redshift.value.username
          password = redshift.value.password
        }
      }
      dynamic "sapo_data" {
        for_each = var.connector_profile_credentials.sapo_data != null ? [var.connector_profile_credentials.sapo_data] : []
        content {
          dynamic "basic_auth_credentials" {
            for_each = sapo_data.value.basic_auth_credentials != null ? [sapo_data.value.basic_auth_credentials] : []
            content {
              username = basic_auth_credentials.value.username
              password = basic_auth_credentials.value.password
            }
          }
          dynamic "oauth_credentials" {
            for_each = sapo_data.value.oauth_credentials != null ? [sapo_data.value.oauth_credentials] : []
            content {
              access_token  = oauth_credentials.value.access_token
              client_id     = oauth_credentials.value.client_id
              client_secret = oauth_credentials.value.client_secret
              refresh_token = oauth_credentials.value.refresh_token
              dynamic "oauth_request" {
                for_each = oauth_credentials.value.oauth_request != null ? [oauth_credentials.value.oauth_request] : []
                content {
                  auth_code    = oauth_request.value.auth_code
                  redirect_uri = oauth_request.value.redirect_uri
                }
              }
            }
          }
        }
      }
      dynamic "service_now" {
        for_each = var.connector_profile_credentials.service_now != null ? [var.connector_profile_credentials.service_now] : []
        content {
          username = service_now.value.username
          password = service_now.value.password
        }
      }
      dynamic "snowflake" {
        for_each = var.connector_profile_credentials.snowflake != null ? [var.connector_profile_credentials.snowflake] : []
        content {
          username = snowflake.value.username
          password = snowflake.value.password
        }
      }
      dynamic "veeva" {
        for_each = var.connector_profile_credentials.veeva != null ? [var.connector_profile_credentials.veeva] : []
        content {
          username = veeva.value.username
          password = veeva.value.password
        }
      }
      dynamic "google_analytics" {
        for_each = var.connector_profile_credentials.google_analytics != null ? [var.connector_profile_credentials.google_analytics] : []
        content {
          client_id     = google_analytics.value.client_id
          client_secret = google_analytics.value.client_secret
          access_token  = google_analytics.value.access_token
          refresh_token = google_analytics.value.refresh_token
          dynamic "oauth_request" {
            for_each = google_analytics.value.oauth_request != null ? [google_analytics.value.oauth_request] : []
            content {
              auth_code    = oauth_request.value.auth_code
              redirect_uri = oauth_request.value.redirect_uri
            }
          }
        }
      }
    }

    connector_profile_properties {
      dynamic "custom_connector" {
        for_each = var.connector_profile_properties.custom_connector != null ? [var.connector_profile_properties.custom_connector] : []
        content {
          profile_properties = custom_connector.value.profile_properties
          dynamic "oauth2_properties" {
            for_each = custom_connector.value.oauth2_properties != null ? [custom_connector.value.oauth2_properties] : []
            content {
              oauth2_grant_type           = oauth2_properties.value.oauth2_grant_type
              token_url                   = oauth2_properties.value.token_url
              token_url_custom_properties = oauth2_properties.value.token_url_custom_properties
            }
          }
        }
      }
      dynamic "redshift" {
        for_each = var.connector_profile_properties.redshift != null ? [var.connector_profile_properties.redshift] : []
        content {
          bucket_name        = redshift.value.bucket_name
          bucket_prefix      = redshift.value.bucket_prefix
          cluster_identifier = redshift.value.cluster_identifier
          database_name      = redshift.value.database_name
          database_url       = redshift.value.database_url
          data_api_role_arn  = redshift.value.data_api_role_arn
          role_arn           = redshift.value.role_arn
        }
      }
      dynamic "sapo_data" {
        for_each = var.connector_profile_properties.sapo_data != null ? [var.connector_profile_properties.sapo_data] : []
        content {
          application_host_url      = sapo_data.value.application_host_url
          application_service_path  = sapo_data.value.application_service_path
          client_number             = sapo_data.value.client_number
          logon_language            = sapo_data.value.logon_language
          port_number               = sapo_data.value.port_number
          private_link_service_name = sapo_data.value.private_link_service_name
          dynamic "oauth_properties" {
            for_each = sapo_data.value.oauth_properties != null ? [sapo_data.value.oauth_properties] : []
            content {
              auth_code_url = oauth_properties.value.oauth_code_url
              oauth_scopes  = oauth_properties.value.oauth_scopes
              token_url     = oauth_properties.value.token_url
            }
          }
        }
      }
      dynamic "service_now" {
        for_each = var.connector_profile_properties.service_now != null ? [var.connector_profile_properties.service_now] : []
        content {
          instance_url = service_now.value.instance_url
        }
      }
      dynamic "snowflake" {
        for_each = var.connector_profile_properties.snowflake != null ? [var.connector_profile_properties.snowflake] : []
        content {
          account_name              = snowflake.value.account_name
          bucket_name               = snowflake.value.bucket_name
          bucket_prefix             = snowflake.value.bucket_prefix
          private_link_service_name = snowflake.value.private_link_service_name
          region                    = snowflake.value.region
          stage                     = snowflake.value.stage
          warehouse                 = snowflake.value.warehouse
        }
      }
      dynamic "veeva" {
        for_each = var.connector_profile_properties.veeva != null ? [var.connector_profile_properties.veeva] : []
        content {
          instance_url = veeva.value.instance_url
        }
      }
      dynamic "google_analytics" {
        for_each = var.connector_profile_properties.google_analytics != null ? [var.connector_profile_properties.google_analytics] : []
        content {
          # EMPTY BECAUSE ATTRIBUTES ARE NOT SPECIFIED IN TERRAFORM OR AWS CLOUDFORMATION DOCS
        }
      }
    }
  }
}

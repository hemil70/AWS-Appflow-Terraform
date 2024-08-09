resource "aws_appflow_connector_profile" "connector_profile" {
  name            = var.connector_profile_name
  connection_mode = var.connection_mode
  connector_label = var.connector_label
  connector_type  = var.connector_type
  connector_profile_config {
    connector_profile_credentials {
      custom_connector {
        authentication_type = var.authentication.type
        dynamic "basic" {
          for_each = var.authentication.type == "BASIC" ? [1] : []
          content {
            username = var.authentication.basic.username
            password = var.authentication.basic.password
          }
        }
        dynamic "api_key" {
          for_each = var.authentication.type == "APIKEY" ? [1] : []
          content {
            api_key        = var.authentication.api_key.api_key
            api_secret_key = var.authentication.api_key.api_secret_key
          }
        }
        dynamic "oauth2" {
          for_each = var.authentication.type == "OAUTH2" ? [1] : []
          content {
            access_token  = var.authentication.oauth2.access_token
            client_id     = var.authentication.oauth2.client_id
            client_secret = var.authentication.oauth2.client_secret
            refresh_token = var.authentication.oauth2.refresh_token
            oauth_request {
              auth_code    = var.authentication.oauth2.oauth_request.auth_code
              redirect_uri = var.authentication.oauth2.oauth_request.redirect_uri
            }
          }
        }
        dynamic "custom" {
          for_each = var.authentication.type == "CUSTOM" ? [1] : []
          content {
            custom_authentication_type = var.authentication.custom.custom_authentication_type
            credentials_map            = var.authentication.custom.credentials_map
          }
        }
      }
    }
    connector_profile_properties {
      custom_connector {
        oauth2_properties {
          oauth2_grant_type           = var.properties.oauth2_properties.oauth2_grant_type
          token_url                   = var.properties.oauth2_properties.token_url
          token_url_custom_properties = var.properties.oauth2_properties.token_url_custom_properties
        }
        profile_properties = var.properties.profile_properties
      }
    }
  }
}

resource "aws_appflow_flow" "appflow" {
  name = var.flow_name

  source_flow_config {
    connector_type = var.connector_type
    api_version    = var.api_version
    source_connector_properties {
      custom_connector {
        entity_name       = var.source_connector_properties.entity_name
        custom_properties = var.source_connector_properties.custom_properties
      }
    }
    connector_profile_name = aws_appflow_connector_profile.connector_profile.name
  }

  destination_flow_config {
    connector_type = var.destination_connector_type
    destination_connector_properties {
      s3 {
        bucket_name = var.destination_bucket_name
      }
    }
  }

  task {
    source_fields = var.task.source_fields
    task_type     = var.task.task_type
    connector_operator {
      s3 = "NO_OP"
    }
    destination_field = var.task.destination_field
    task_properties   = var.task.task_properties
  }

  trigger_config {
    trigger_type = var.trigger_type

    dynamic "trigger_properties" {
      for_each = var.trigger_type == "scheduled" ? [var.trigger_properties] : []

      content {
        scheduled {
          schedule_expression  = trigger_properties.value.schedule_expression
          data_pull_mode       = trigger_properties.value.data_pull_mode
          first_execution_from = trigger_properties.value.first_execution_from
          schedule_end_time    = trigger_properties.value.schedule_end_time
          schedule_offset      = trigger_properties.value.schedule_offset
          schedule_start_time  = trigger_properties.value.schedule_start_time
          timezone             = trigger_properties.value.timezone
        }
      }
    }
  }
}
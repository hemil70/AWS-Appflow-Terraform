variable "connector_profile_name" {
  type        = string
  description = "Name of appflow connector profile"
}

variable "connection_mode" {
  type        = string
  description = "connection mode type : Public or Private"
  default     = "Public"

  validation {
    condition     = contains(["Public", "Private"], var.connection_mode)
    error_message = "Invalid value for 'connection_mode'. Allowed values are 'Public' and 'Private'."
  }
}

variable "connector_label" {
  type        = string
  description = "connector label"
  default     = "GitHub"
}

variable "connector_type" {
  type        = string
  description = "connector type"
  default     = "CustomConnector"
}

variable "authentication" {
  description = "Authentication details based on the selected type."
  type = object({
    type = string
    basic = optional(object({
      username = string
      password = string
    }))
    api_key = optional(object({
      api_key        = string
      api_secret_key = optional(string)
    }))
    oauth2 = optional(object({
      access_token  = optional(string)
      client_id     = optional(string)
      client_secret = optional(string)
      refresh_token = optional(string)
      oauth_request = object({
        auth_code    = optional(string)
        redirect_uri = optional(string)
      })
    }))
    custom = optional(object({
      custom_authentication_type = string
      credentials_map            = optional(map(string))
    }))
  })
  default = {
    type = "CUSTOM"
    basic = {
      username = null
      password = null
    }
    api_key = {
      api_key        = null
      api_secret_key = null
    }
    oauth2 = {
      access_token  = null
      client_id     = null
      client_secret = null
      refresh_token = null
      oauth_request = {
        auth_code    = null
        redirect_uri = null
      }
    }
    custom = {
      custom_authentication_type = null
      credentials_map            = null
    }
  }
  validation {
    condition     = contains(["BASIC", "API_KEY", "OAUTH2", "CUSTOM"], var.authentication.type)
    error_message = "Invalid value for 'type'. Allowed values are 'BASIC', 'API_KEY', 'OAUTH2', and 'CUSTOM'."
  }
}

variable "properties" {
  description = "Configuration for the custom connector."
  type = object({
    oauth2_properties = optional(object({
      oauth2_grant_type           = string
      token_url                   = string
      token_url_custom_properties = optional(map(string))
    }))
    profile_properties = optional(map(string))
  })
  default = {
    oauth2_properties = {
      oauth2_grant_type           = null
      token_url                   = null
      token_url_custom_properties = null
    }
    profile_properties = null
  }
}

variable "flow_name" {
  type        = string
  description = "appflow name"
}

variable "api_version" {
  type        = string
  description = "API Version"
}
variable "source_connector_properties" {
  type = object({
    entity_name       = string
    custom_properties = optional(map(string))
  })
}

variable "destination_connector_type" {
  type        = string
  description = "Destionation service e.g S3 or snowflake"
}

variable "task" {
  type = object({
    source_fields     = list(string)
    task_type         = string
    destination_field = optional(string)
    task_properties   = optional(map(string))
  })
}

variable "trigger_type" {
  type        = string
  description = "Flow Trigger type"

  validation {
    condition     = contains(["Scheduled", "Event", "OnDemand"], var.trigger_type)
    error_message = "Invalid value for 'type'. Allowed values are 'Scheduled', 'Event', and 'OnDemand'."
  }
}

variable "trigger_properties" {
  type = object({
    schedule_expression  = string
    data_pull_mode       = optional(string)
    first_execution_from = optional(string)
    schedule_end_time    = optional(string)
    schedule_offset      = optional(number)
    schedule_start_time  = optional(string)
    timezone             = optional(string)
  })
  default = null

  description = "Properties for scheduling the trigger."
}
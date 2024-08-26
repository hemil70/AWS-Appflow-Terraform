variable "connector_profile_name" {
  type        = string
  description = "The unique name of the connector profile in your AWS account"
}

variable "connector_profile_connection_mode" {
  type        = string
  description = "'Public' routes data over the internet, while 'Private' uses AWS PrivateLink, ensuring data doesn't traverse the public internet"
  default     = "Public"

  validation {
    condition     = var.connector_profile_connection_mode == "Public" || var.connector_profile_connection_mode == "Private"
    error_message = "connector_profile_connection_mode must be either 'Public' or 'Private'"
  }
}

variable "connector_profile_connector_type" {
  type        = string
  description = "Allowerd Values : CustomConnector, Redshift, SAPOData, Servicenow, Snowflake, Veeva, Googleanalytics"

  validation {
    condition     = contains(["CustomConnector", "Redshift", "SAPOData", "Servicenow", "Snowflake", "Veeva", "Googleanalytics"], var.connector_profile_connector_type)
    error_message = "connector_profile_connector_type must be one of: 'CustomConnector', 'Redshift', 'SAPOData', 'Servicenow', 'Snowflake', 'Veeva', 'Googleanalytics'"
  }
}

variable "connector_profile_connector_label" {
  type        = string
  description = "The unique label for each ConnectorRegistration in your AWS account. Required if calling for CustomConnector connector type. Allowed values are 'GitHub', 'MicrosoftTeams', 'GitLab', 'GoogleBigQuery', 'JiraCloud', 'MicrosoftDynamics365', 'MicrosoftSharePointOnline', 'SalesforceMarketingCloud', and 'Zoom'"
  default     = null
}


variable "connector_profile_kms_arn" {
  type        = string
  description = "ARN of the KMS key you provide for encryption"
  default     = null
}

variable "connector_profile_credentials" {
  description = "The connector-specific credentials required by each connector"
  type = object({
    custom_connector = optional(object({
      authentication_type = string # The authentication type that the custom connector uses for authenticating while creating a connector profile. One of: "APIKEY", "BASIC", "CUSTOM", "OAUTH2"
      api_key = optional(object({
        api_key        = string
        api_secret_key = optional(string)
      }))
      basic = optional(object({
        username = string
        password = string
      }))
      custom = optional(object({
        custom_authentication_type = string
        credentials_map            = optional(map(string))
      }))
      oauth2 = optional(object({
        access_token  = optional(string) # The access token used to access the connector on your behalf
        client_id     = optional(string) # The identifier for the desired client
        client_secret = optional(string) # The client secret used by the OAuth client to authenticate to the authorization server
        refresh_token = optional(string) #  The refresh token used to refresh an expired access token
        oauth_request = optional(object({
          auth_code    = optional(string) # The code provided by the connector when it has been authenticated via the connected app
          redirect_uri = optional(string) # The URL to which the authentication server redirects the browser after authorization has been granted
        }))
      }))
    }))
    veeva = optional(object({
      username = string
      password = string
    }))
    snowflake = optional(object({
      username = string
      password = string
    }))
    service_now = optional(object({
      username = string
      password = string
    }))
    redshift = optional(object({
      username = string
      password = string
    }))
    sapo_data = optional(object({
      basic_auth_credentials = optional(object({
        username = string
        password = string
      }))
      oauth_credentials = optional(object({
        access_token  = optional(string) # The access token used to access protected SAPOData resources
        client_id     = string           # The identifier for the desired client
        client_secret = string           # The client secret used by the OAuth client to authenticate to the authorization server
        refresh_token = optional(string) # The refresh token used to refresh expired access token
        oauth_request = optional(object({
          auth_code    = optional(string) # The code provided by the connector when it has been authenticated via the connected app
          redirect_uri = optional(string) # The URL to which the authentication server redirects the browser after authorization has been granted
        }))
      }))
    }))
    google_analytics = optional(object({
      client_id     = string
      client_secret = string
      access_token  = optional(string)
      refresh_token = optional(string)
      oauth_request = optional(object({
        auth_code    = optional(string) # The code provided by the connector when it has been authenticated via the connected app
        redirect_uri = optional(string) # The URL to which the authentication server redirects the browser after authorization has been granted
      }))
    }))
  })
  validation {
    condition     = var.connector_profile_credentials.custom_connector != null || var.connector_profile_credentials.veeva != null || var.connector_profile_credentials.snowflake != null || var.connector_profile_credentials.service_now != null || var.connector_profile_credentials.redshift != null || var.connector_profile_credentials.sapo_data != null || var.connector_profile_credentials.google_analytics != null
    error_message = "At least one of the connector profile credentials must be defined."
  }
  default = {
    custom_connector = null
    veeva            = null
    snowflake        = null
    service_now      = null
    redshift         = null
    sapo_data        = null
    google_analytics = null
  }
}

variable "connector_profile_properties" {
  description = "The connector-specific properties of the profile configuration"
  type = object({
    custom_connector = optional(object({
      profile_properties = optional(map(string)) # A map of properties that are required to create a profile for the custom connector
      oauth2_properties = optional(object({
        oauth2_grant_type           = string                # The OAuth 2.0 grant type used by connector for OAuth 2.0 authentication. One of: AUTHORIZATION_CODE, CLIENT_CREDENTIALS
        token_url                   = string                # The token URL required for OAuth 2.0 authentication
        token_url_custom_properties = optional(map(string)) # Associates your token URL with a map of properties that you define. Use this parameter to provide any additional details that the connector requires to authenticate your request
      }))
    }))
    veeva = optional(object({
      instance_url = string # The instance URL for the veeva environment
    }))
    snowflake = optional(object({
      account_name              = optional(string) # The name of the account
      bucket_name               = string           # The name of the Amazon S3 bucket associated with Snowflake
      bucket_prefix             = optional(string) # The bucket path that refers to the Amazon S3 bucket associated with Snowflake
      private_link_service_name = optional(string) # The Snowflake Private Link service name to be used for private data transfers
      region                    = optional(string) # AWS Region of the Snowflake account
      stage                     = string           # Name of the Amazon S3 stage that was created while setting up an Amazon S3 stage in the Snowflake account. This is written in the following format: <Database>.<Schema>.<Stage Name>
      warehouse                 = string           # The name of the Snowflake warehouse
    }))
    service_now = optional(object({
      instance_url = string # The instance URL for the ServiceNow environment
    }))
    redshift = optional(object({
      bucket_name        = string           # A name for the associated Amazon S3 bucket
      bucket_prefix      = optional(string) # The object key for the destination bucket in which Amazon AppFlow places the files
      cluster_identifier = optional(string) # The unique ID that's assigned to an Amazon Redshift cluster
      database_name      = optional(string) # The name of an Amazon Redshift database
      database_url       = string           # The JDBC URL of the Amazon Redshift cluster
      data_api_role_arn  = optional(string) # ARN of the IAM role that permits AppFlow to access the database through Data API
      role_arn           = string           # ARN of the IAM role
    }))
    sapo_data = optional(object({
      application_host_url      = string           # The host URL for the SAP OData application
      application_service_path  = string           # The application path to catalog service
      client_number             = number           # The client number for the client creating the connection
      logon_language            = optional(string) # The logon language of SAPOData instance
      port_number               = number           # The port number of the SAPOData instance
      private_link_service_name = optional(string) # The SAPOData Private Link service name to be used for private data transfers
      oauth_properties = optional(object({
        auth_code_url = string # The authorization code url required to redirect to SAP Login Page to fetch authorization code for OAuth type authentication
        oauth_scopes  = string # The OAuth scopes required for OAuth type authentication
        token_url     = string # The token url required to fetch access/refresh tokens using authorization code and also to refresh expired access token using refresh token
      }))
    }))
    google_analytics = optional(object({
      # EMPTY BECAUSE ATTRIBUTES ARE NOT SPECIFIED IN TERRAFORM OR AWS CLOUDFORMATION DOCS
    }))
  })
  default = {
    custom_connector = null
    veeva            = null
    snowflake        = null
    service_now      = null
    redshift         = null
    sapo_data        = null
    google_analytics = null
  }
}

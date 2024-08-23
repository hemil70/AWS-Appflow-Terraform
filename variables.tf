variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Bucket force destroy"
  type        = bool
}

variable "secret_name" {
  type = string
}

variable "github" {
  type = object({
    username = string
    PAT      = string
  })

}
variable "connector_profile" {
  type = object({
    name                       = string
    connector_type             = string
    connector_label            = string
    authentication_type        = string
    custom_authentication_type = string
    oauth2_grant_type          = string
    token_url                  = string
  })
}

variable "appflow" {
  type = object({
    flow_name                  = string
    source_connector_type      = string
    api_version                = string
    entity_name                = string
    destination_connector_type = string
    tasks = list(object({
      source_fields      = list(string)
      task_type          = string
      connector_type     = string # Type of the connector, e.g., "s3", "sapo_data"
      connector_operator = string # Value for the connector operator
      destination_field  = optional(string)
      task_properties    = optional(map(string)) # Optional
    }))
  })
}
variable "flow_name" {
  type        = string
  description = "Name of the flow"
}

variable "description" {
  type        = string
  description = "Description of the flow"
  default     = null
}

variable "kms_arn" {
  type        = string
  description = "ARN of the KMS key you provide for encryption"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tag map for the resource"
  default     = null
}

variable "metadata_catalog_config" {
  description = "A Catalog that determines the configuration that Amazon AppFlow uses when it catalogs the data that’s transferred by the associated flow. When Amazon AppFlow catalogs the data from a flow, it stores metadata in a data catalog"
  type = object({
    database_name = string # The name of an existing Glue database to store the metadata tables that Amazon AppFlow creates
    role_arn      = string # The ARN of an IAM role that grants AppFlow the permissions it needs to create Data Catalog tables, databases, and partitions
    table_prefix  = string # A naming prefix for each Data Catalog table that Amazon AppFlow creates
  })
  default = null
}

variable "source_connector_type" {
  description = "Type of Source connector, such as Servicenow, S3, and so on"
  type        = string

  validation {
    condition     = contains(["S3", "Servicenow", "Veeva", "SAPOData", "CustomConnector"], var.source_connector_type)
    error_message = "Invalid source_connector_type. Valid values are Only S3, Servicenow, SAPOData, Veeva and CustomConnector"
  }
}

variable "api_version" {
  type        = string
  description = "API version that the destination connector uses"
  default     = null
}

variable "source_connector_profile_name" {
  type        = string
  description = "Name of the connector profile. This name must be unique for each connector profile in the AWS account"
  default     = null
}

variable "incremental_pull_config" {
  description = "Defines the configuration for a scheduled incremental data pull. If a valid configuration is provided, the fields specified in the configuration are used when querying for the incremental data pull"
  type = object({
    datetime_type_field_name = string # Field that specifies the date time or timestamp field as the criteria to use when importing incremental records from the source.
  })
  default = null
}

variable "source_connector_properties" {
  description = "Properties that are required to query a particular source connector"
  type = object({
    s3 = optional(object({
      bucket_name   = string               # Amazon S3 bucket name where the source files are stored
      bucket_prefix = optional(string, "") # Object key for the Amazon S3 bucket in which the source files are stored
      s3_input_format_config = optional(object({
        s3_input_file_type = optional(string, "JSON") # File type that Amazon AppFlow gets from your Amazon S3 bucket. Valid values are CSV and JSON
      }))
    }))
    veeva = optional(object({
      object               = string           # Object specified in the Veeva flow source
      document_type        = optional(string) # Document type specified in the Veeva document extract flow
      include_all_versions = optional(bool)
      include_renditions   = optional(bool)
      include_source_files = optional(bool)
    }))
    sapo_data = optional(object({
      object_path = string # Object path specified in the SAPOData flow source
    }))
    service_now = optional(object({
      object = string # Object specified in the flow source
    }))
    custom_connector = optional(object({
      entity_name       = string                # Entity specified in the custom connector as a source in the flow
      custom_properties = optional(map(string)) # Custom properties that are specific to the connector when it's used as a source in the flow. Maximum of 50 items.
    }))
  })
  default = {
    s3 = {
      bucket_name   = null
      bucket_prefix = ""
      s3_input_format_config = {
        s3_input_file_type = "JSON"
      }
    }
    veeva = {
      object               = null
      document_type        = ""
      include_all_versions = false
      include_renditions   = false
      include_source_files = false
    }
    sapo_data = {
      object_path = null
    }
    service_now = {
      object = null
    }
    custom_connector = {
      entity_name       = null
      custom_properties = {}
    }
  }
}

variable "destination_connector_type" {
  description = "Type of Destination connector, such as Redshift, S3, and so on"
  type        = string

  validation {
    condition     = contains(["S3", "Redshift", "Snowflake", "CustomConnector"], var.destination_connector_type)
    error_message = "Invalid destination_connector_type. Valid values are Only S3, Redshift, CustomConnector and Snowflake"
  }
}

variable "destination_connector_profile_name" {
  type        = string
  description = "Name of the connector profile. This name must be unique for each connector profile in the AWS account"
  default     = null
}

variable "destination_connector_properties" {
  description = "Properties that are required to query a particular destination connector"
  type = object({
    s3 = optional(object({
      bucket_name   = string
      bucket_prefix = optional(string)
      s3_output_format_config = optional(object({
        file_type = optional(string, "JSON") # File type that Amazon AppFlow places in the Amazon S3 bucket. Valid values are CSV, JSON, and PARQUET
        aggregation_config = object({
          aggregation_type = optional(string) # Whether Amazon AppFlow aggregates the flow records into a single file, or leave them unaggregated. Valid values are None and SingleFile
          target_file_size = optional(number) # The desired file size, in MB, for each output file that Amazon AppFlow writes to the flow destination. Integer value.
        })
        prefix_config = optional(object({
          prefix_format    = string       # Determines the level of granularity that's included in the prefix. Valid values are YEAR, MONTH, DAY, HOUR, and MINUTE
          prefix_type      = string       # Determines the format of the prefix, and whether it applies to the file name, file path, or both. Valid values are FILENAME, PATH, and PATH_AND_FILENAME
          prefix_hierarchy = list(string) # Determines whether the destination file path includes either or both of the selected elements. Valid values are EXECUTION_ID and SCHEMA_VERSION
        }))
        preserve_source_data_typing = optional(bool) # Whether the data types from the source system need to be preserved (Only valid for Parquet file type)
      }))
    }))
    custom_connector = optional(object({
      error_handling_config = object({
        bucket_name                     = optional(string)
        bucket_prefix                   = optional(string)
        fail_on_first_destination_error = optional(bool)
      })
      entity_name          = string                 # Entity specified in the custom connector as a destination in the flow.
      custom_properties    = optional(map(string))  # Custom properties that are specific to the connector when it's used as a destination in the flow. Maximum of 50 items.
      id_field_names       = optional(list(string)) # Name of the field that Amazon AppFlow uses as an ID when performing a write operation such as update, delete, or upsert.
      write_operation_type = string                 # Type of write operation to be performed in the custom connector when it's used as destination. Valid values are INSERT, UPSERT, UPDATE, and DELETE
    }))
    redshift = optional(object({
      error_handling_config = object({
        bucket_name                     = optional(string)
        bucket_prefix                   = optional(string)
        fail_on_first_destination_error = optional(bool)
      })
      intermediate_bucket_name = string           # Intermediate bucket that Amazon AppFlow uses when moving data into Amazon Redshift.
      bucket_prefix            = optional(string) # Object key for the bucket in which Amazon AppFlow places the destination files.
      object                   = optional(string) # Object specified in the Amazon Redshift flow destination.
    }))
    snowflake = optional(object({
      error_handling_config = optional(object({
        bucket_name                     = optional(string)
        bucket_prefix                   = optional(string)
        fail_on_first_destination_error = optional(bool)
      }))
      intermediate_bucket_name = string           # Intermediate bucket that Amazon AppFlow uses when moving data into Amazon Snowflake.
      bucket_prefix            = optional(string) # Object key for the bucket in which Amazon AppFlow places the destination files.
      object                   = optional(string) # Object specified in the Amazon Snowflake flow destination
    }))
  })
  default = {
    s3               = null
    custom_connector = null
    redshift         = null
    snowflake        = null
  }
}

variable "tasks" {
  description = "List of tasks to be performed in the flow."
  type = list(object({
    source_fields      = list(string)
    task_type          = string
    connector_type     = string # Type of the connector, e.g., "s3", "sapo_data"
    connector_operator = string # Value for the connector operator
    destination_field  = optional(string)
    task_properties    = optional(map(string)) # Optional
  }))
}

variable "trigger_type" {
  type        = string
  description = "Flow Trigger type"
  default     = "OnDemand"

  validation {
    condition     = contains(["Scheduled", "Event", "OnDemand"], var.trigger_type)
    error_message = "Invalid value for 'type'. Allowed values are 'Scheduled', 'Event', and 'OnDemand'."
  }
}

variable "trigger_properties" {
  description = "Configuration details of a schedule-triggered flow as defined by the user. only apply to the 'Scheduled' trigger type"
  type = object({
    schedule_expression  = string
    data_pull_mode       = optional(string)
    first_execution_from = optional(number)
    schedule_end_time    = optional(number)
    schedule_offset      = optional(number)
    schedule_start_time  = optional(number)
    timezone             = optional(string)
  })
  default = null
}

resource "aws_appflow_flow" "appflow" {
  name        = var.flow_name
  description = var.description
  kms_arn     = var.kms_arn
  tags        = var.tags
  dynamic "metadata_catalog_config" {
    for_each = var.metadata_catalog_config != null ? [var.metadata_catalog_config] : []
    content {
      glue_data_catalog {
        database_name = metadata_catalog_config.value.database_name
        role_arn      = metadata_catalog_config.value.role_arn
        table_prefix  = metadata_catalog_config.value.table_prefix
      }
    }
  }

  source_flow_config {
    connector_type         = var.source_connector_type
    api_version            = var.api_version
    connector_profile_name = var.source_connector_profile_name
    dynamic "incremental_pull_config" {
      for_each = var.incremental_pull_config != null ? [var.incremental_pull_config] : []
      content {
        datetime_type_field_name = incremental_pull_config.value.datetime_type_field_name
      }
    }

    source_connector_properties {
      dynamic "s3" {
        for_each = var.source_connector_properties.s3 != null ? [var.source_connector_properties.s3] : []
        content {
          bucket_name   = s3.value.bucket_name
          bucket_prefix = s3.value.bucket_prefix
          dynamic "s3_input_format_config" {
            for_each = s3.value.s3_input_format_config != null ? [s3.value.s3_input_format_config] : []
            content {
              s3_input_file_type = s3_input_format_config.value.s3_input_file_type
            }
          }
        }
      }
      dynamic "sapo_data" {
        for_each = var.source_connector_properties.sapo_data != null ? [var.source_connector_properties.sapo_data] : []
        content {
          object_path = sapo_data.value.object_path
        }
      }
      dynamic "service_now" {
        for_each = var.source_connector_properties.service_now != null ? [var.source_connector_properties.service_now] : []
        content {
          object = service_now.value.object
        }
      }
      dynamic "veeva" {
        for_each = var.source_connector_properties.veeva != null ? [var.source_connector_properties.veeva] : []
        content {
          object               = veeva.value.object
          document_type        = veeva.value.document_type
          include_all_versions = veeva.value.include_all_versions
          include_renditions   = veeva.value.include_renditions
          include_source_files = veeva.value.include_source_files
        }
      }
      dynamic "custom_connector" {
        for_each = var.source_connector_properties.custom_connector != null ? [var.source_connector_properties.custom_connector] : []
        content {
          entity_name       = custom_connector.value.entity_name
          custom_properties = custom_connector.value.custom_properties
        }
      }
    }
  }

  destination_flow_config {
    connector_type         = var.destination_connector_type
    api_version            = var.api_version
    connector_profile_name = var.destination_connector_profile_name

    destination_connector_properties {
      dynamic "redshift" {
        for_each = var.destination_connector_properties.redshift != null ? [var.destination_connector_properties.redshift] : []
        content {
          intermediate_bucket_name = redshift.value.intermediate_bucket_name
          object                   = redshift.value.object
          bucket_prefix            = redshift.value.bucket_prefix
          dynamic "error_handling_config" {
            for_each = redshift.value.error_handling_config != null ? [redshift.value.error_handling_config] : []
            content {
              bucket_name                     = error_handling_config.value.entity_name
              bucket_prefix                   = error_handling_config.value.bucket_prefix
              fail_on_first_destination_error = error_handling_config.value.fail_on_first_destination_error
            }
          }
        }
      }
      dynamic "s3" {
        for_each = var.destination_connector_properties.s3 != null ? [var.destination_connector_properties.s3] : []
        content {
          bucket_name   = s3.value.bucket_name
          bucket_prefix = s3.value.bucket_prefix
          dynamic "s3_output_format_config" {
            for_each = s3.value.s3_output_format_config != null ? [s3.value.s3_output_format_config] : []
            content {
              file_type                   = s3_output_format_config.value.file_type
              preserve_source_data_typing = s3_output_format_config.value.preserve_source_data_typing
              dynamic "aggregation_config" {
                for_each = s3_output_format_config.value.aggregation_config != null ? [s3_output_format_config.value.aggregation_config] : []
                content {
                  aggregation_type = aggregation_config.value.aggregation_type
                  target_file_size = aggregation_config.value.target_file_size
                }
              }
              dynamic "prefix_config" {
                for_each = s3_output_format_config.value.prefix_config != null ? [s3_output_format_config.value.prefix_config] : []
                content {
                  prefix_format    = prefix_config.value.prefix_format
                  prefix_type      = prefix_config.value.prefix_type
                  prefix_hierarchy = prefix_config.value.prefix_hierarchy
                }
              }
            }
          }
        }
      }
      dynamic "snowflake" {
        for_each = var.destination_connector_properties.snowflake != null ? [var.destination_connector_properties.snowflake] : []
        content {
          intermediate_bucket_name = snowflake.value.intermediate_bucket_name
          object                   = snowflake.value.object
          bucket_prefix            = snowflake.value.bucket_prefix
          dynamic "error_handling_config" {
            for_each = snowflake.value.error_handling_config != null ? [snowflake.value.error_handling_config] : []
            content {
              bucket_name                     = error_handling_config.value.entity_name
              bucket_prefix                   = error_handling_config.value.bucket_prefix
              fail_on_first_destination_error = error_handling_config.value.fail_on_first_destination_error
            }
          }
        }
      }
      dynamic "custom_connector" {
        for_each = var.destination_connector_properties.custom_connector != null ? [var.destination_connector_properties.custom_connector] : []
        content {
          entity_name          = custom_connector.value.entity_name
          custom_properties    = custom_connector.value.custom_properties
          id_field_names       = custom_connector.value.id_field_names
          write_operation_type = custom_connector.value.write_operation_type
          dynamic "error_handling_config" {
            for_each = custom_connector.value.error_handling_config != null ? [custom_connector.value.error_handling_config] : []
            content {
              bucket_name                     = error_handling_config.value.entity_name
              bucket_prefix                   = error_handling_config.value.bucket_prefix
              fail_on_first_destination_error = error_handling_config.value.fail_on_first_destination_error
            }
          }
        }
      }
    }
  }

  dynamic "task" {
    for_each = var.tasks
    content {
      connector_operator {
        s3               = task.value.connector_type == "s3" ? task.value.connector_operator : null
        sapo_data        = task.value.connector_type == "sapo_data" ? task.value.connector_operator : null
        service_now      = task.value.connector_type == "service_now" ? task.value.connector_operator : null
        veeva            = task.value.connector_type == "veeva" ? task.value.connector_operator : null
        custom_connector = task.value.connector_type == "custom_connector" ? task.value.connector_operator : null
      }
      source_fields     = task.value.source_fields
      task_type         = task.value.task_type
      destination_field = try(task.value.destination_field, "")
      task_properties   = task.value.task_properties
    }
  }

  trigger_config {
    trigger_type = var.trigger_type
    dynamic "trigger_properties" {
      for_each = var.trigger_properties != null ? [var.trigger_properties] : []
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

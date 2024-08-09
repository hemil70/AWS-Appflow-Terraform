## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appflow_connector_profile.connector_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appflow_connector_profile) | resource |
| [aws_appflow_flow.appflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appflow_flow) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | API Version | `string` | n/a | yes |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | Authentication details based on the selected type. | <pre>object({<br>    type = string<br>    basic = optional(object({<br>      username = string<br>      password = string<br>    }))<br>    api_key = optional(object({<br>      api_key        = string<br>      api_secret_key = optional(string)<br>    }))<br>    oauth2 = optional(object({<br>      access_token  = optional(string)<br>      client_id     = optional(string)<br>      client_secret = optional(string)<br>      refresh_token = optional(string)<br>      oauth_request = object({<br>        auth_code    = optional(string)<br>        redirect_uri = optional(string)<br>      })<br>    }))<br>    custom = optional(object({<br>      custom_authentication_type = string<br>      credentials_map            = optional(map(string))<br>    }))<br>  })</pre> | <pre>{<br>  "api_key": {<br>    "api_key": null,<br>    "api_secret_key": null<br>  },<br>  "basic": {<br>    "password": null,<br>    "username": null<br>  },<br>  "custom": {<br>    "credentials_map": null,<br>    "custom_authentication_type": null<br>  },<br>  "oauth2": {<br>    "access_token": null,<br>    "client_id": null,<br>    "client_secret": null,<br>    "oauth_request": {<br>      "auth_code": null,<br>      "redirect_uri": null<br>    },<br>    "refresh_token": null<br>  },<br>  "type": "CUSTOM"<br>}</pre> | no |
| <a name="input_connection_mode"></a> [connection\_mode](#input\_connection\_mode) | connection mode type : Public or Private | `string` | `"Public"` | no |
| <a name="input_connector_label"></a> [connector\_label](#input\_connector\_label) | connector label | `string` | `"GitHub"` | no |
| <a name="input_connector_profile_name"></a> [connector\_profile\_name](#input\_connector\_profile\_name) | Name of appflow connector profile | `string` | n/a | yes |
| <a name="input_connector_type"></a> [connector\_type](#input\_connector\_type) | connector type | `string` | `"CustomConnector"` | no |
| <a name="input_destination_bucket_name"></a> [destination\_bucket\_name](#input\_destination\_bucket\_name) | Destination s3 bucket name | `string` | n/a | yes |
| <a name="input_destination_connector_type"></a> [destination\_connector\_type](#input\_destination\_connector\_type) | Destionation service e.g S3 or snowflake | `string` | n/a | yes |
| <a name="input_flow_name"></a> [flow\_name](#input\_flow\_name) | appflow name | `string` | n/a | yes |
| <a name="input_properties"></a> [properties](#input\_properties) | Configuration for the custom connector. | <pre>object({<br>    oauth2_properties = optional(object({<br>      oauth2_grant_type           = string<br>      token_url                   = string<br>      token_url_custom_properties = optional(map(string))<br>    }))<br>    profile_properties = optional(map(string))<br>  })</pre> | <pre>{<br>  "oauth2_properties": {<br>    "oauth2_grant_type": null,<br>    "token_url": null,<br>    "token_url_custom_properties": null<br>  },<br>  "profile_properties": null<br>}</pre> | no |
| <a name="input_source_connector_properties"></a> [source\_connector\_properties](#input\_source\_connector\_properties) | n/a | <pre>object({<br>    entity_name       = string<br>    custom_properties = optional(map(string))<br>  })</pre> | n/a | yes |
| <a name="input_task"></a> [task](#input\_task) | n/a | <pre>object({<br>    source_fields     = list(string)<br>    task_type         = string<br>    destination_field = optional(string)<br>    task_properties   = optional(map(string))<br>  })</pre> | n/a | yes |
| <a name="input_trigger_properties"></a> [trigger\_properties](#input\_trigger\_properties) | Properties for scheduling the trigger. | <pre>object({<br>    schedule_expression  = string<br>    data_pull_mode       = optional(string)<br>    first_execution_from = optional(string)<br>    schedule_end_time    = optional(string)<br>    schedule_offset      = optional(number)<br>    schedule_start_time  = optional(string)<br>    timezone             = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_trigger_type"></a> [trigger\_type](#input\_trigger\_type) | Flow Trigger type | `string` | n/a | yes |

## Outputs

No outputs.

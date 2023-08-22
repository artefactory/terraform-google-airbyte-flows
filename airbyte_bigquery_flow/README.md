## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_airbyte"></a> [airbyte](#requirement\_airbyte) | 0.1.21 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_airbyte"></a> [airbyte](#provider\_airbyte) | 0.1.21 |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [airbyte_connection.connection](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/resources/connection) | resource |
| [airbyte_destination.bigquery_destination](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/resources/destination) | resource |
| [airbyte_operation.normalization](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/resources/operation) | resource |
| [airbyte_source.source](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/resources/source) | resource |
| [airbyte_source_definition.custom_source](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/resources/source_definition) | resource |
| [google_storage_hmac_key.hmac_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_hmac_key) | resource |
| [airbyte_source_schema_catalog.source_schema_catalog](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/data-sources/source_schema_catalog) | data source |
| [airbyte_workspace_ids.workspaces](https://registry.terraform.io/providers/josephjohncox/airbyte/0.1.21/docs/data-sources/workspace_ids) | data source |
| [google_secret_manager_secret_version.source_configuration_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airbyte_service_account_email"></a> [airbyte\_service\_account\_email](#input\_airbyte\_service\_account\_email) | Email address of the service account used by Airbyte | `string` | n/a | yes |
| <a name="input_flow_configuration"></a> [flow\_configuration](#input\_flow\_configuration) | Source -> BigQuery Airbyte flow configuration. Supports all of the Airbyte catalog sources | <pre>object({<br><br>    flow_name   = string # blah blah<br>    source_name = string<br><br>    custom_source = optional(object({<br>      docker_repository = string<br>      docker_image_tag  = string<br>      documentation_url = string<br>    }))<br><br>    cron_schedule = optional(string, "manual")<br>    cron_timezone = optional(string, "UTC")<br><br>    normalize = optional(bool, true)<br><br>    tables_to_sync = map(object({<br>      sync_mode             = optional(string, "full_refresh")<br>      destination_sync_mode = optional(string, "append")<br>      cursor_field          = optional(string)<br>      primary_key           = optional(string)<br>    }))<br><br>    source_specification = map(string)<br><br>    destination_specification = object({<br>      dataset_name        = string<br>      dataset_location    = string<br>      staging_bucket_name = string<br>    })<br><br>    source_catalog_entry = list(object({<br>      sourceDefinitionId = string<br>      spec = object({<br>        connectionSpecification = object({<br>          required = list(string)<br>        })<br>      })<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id in which the existing Airbyte instance resides | `string` | n/a | yes |

## Outputs

No outputs.

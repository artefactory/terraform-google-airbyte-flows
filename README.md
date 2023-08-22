# terraform-google-airbyte-flows
A Terraform module to programmatically deploy end-to-end ELT flows to BigQuery on Airbyte.

## Usage

###[Basic configuration example](./examples/basic/main.tf)
###[YAML configuration example](./examples/yaml/main.tf)
This module is designed to be compatible with external YAML configuration files. It is a convenient way for users not proficient in Terraform to specify/modify ELT pipelines programmatically, or to integrate this module with other tools that can generate YAML files.

### YAML Configuration reference:
```yaml
<flow_1>:
  flow_name: string    # Display name for your data flow
  source_name: string  # Name of the source. Either one from https://docs.airbyte.com/category/sources or a custom one.

  custom_source:               # Default: null. If source_name is not in the Airbyte sources catalog, you need to specify where to find it
    docker_repository: string  # Docker Repository URL (e.g. 112233445566.dkr.ecr.us-east-1.amazonaws.com/source-custom) or DockerHub identifier (e.g. airbyte/source-postgres)
    docker_image_tag: string   # Docker image tag
    documentation_url: string  # Custom source documentation URL

  cron_schedule: string  # Default: manual. Cron expression for when syncs should run (ex. "0 0 12 * * ?" => Will sync at 12:00 PM every day)
  cron_timezone: string  # Default: UTC. One of the TZ identifiers at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

  normalize: bool # Default: true. Whether Airbyte should normalize the data after ingestion. https://docs.airbyte.com/understanding-airbyte/basic-normalization/

  tables_to_sync:                    # All streams to extract from the source and load to BigQuery
    <stream_1>:
      sync_mode: string              # Allowed: full_refresh | incremental. Default: full_refresh
      destination_sync_mode: string  # Allowed: append | overwrite | append_dedup. Default: append
      cursor_field: string           # Path to the field that will be used to determine if a record is new or modified since the last sync. This field is REQUIRED if sync_mode is incremental. Otherwise it is ignored.
      primary_key:                   # List of the fields that will be used as primary key (multiple fields can be listed for a composite PK). This field is REQUIRED if destination_sync_mode is *_dedup. Otherwise it is ignored.
        - string
        - string

    <stream_2>:
      ...

  source_specification:      # Source-specific configurations
    <source_spec_1>: any     # The types are defined by the source connector
    <source_spec_2>: any     # For any string like "secret:<secret_name>", the module will fetch the value of `secret_name` in the Secret Manager.

  destination_specification:
    dataset_name: string         # Existing dataset to which your data will be written
    dataset_location: string     # Allowed: EU | US | Any valid BQ region as specified here https://cloud.google.com/bigquery/docs/locations
    staging_bucket_name: string  # Existing bucket in which your data will be written as avro files at each connection run.

<flow_2>:
  ...
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_airbyte"></a> [airbyte](#requirement\_airbyte) | ~>0.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>4.75 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~>3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | ~>3.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_salesforce_bigquery_flow"></a> [salesforce\_bigquery\_flow](#module\_salesforce\_bigquery\_flow) | ./airbyte_bigquery_flow | n/a |

## Resources

| Name | Type |
|------|------|
| [http_http.connectors_catalog](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airbyte_service_account_email"></a> [airbyte\_service\_account\_email](#input\_airbyte\_service\_account\_email) | Email address of the service account used by the Airbyte VM | `string` | n/a | yes |
| <a name="input_flows_configuration"></a> [flows\_configuration](#input\_flows\_configuration) | n/a | <pre>map(object({<br>    flow_name   = string<br>    source_name = string<br><br>    custom_source = optional(object({<br>      docker_repository = string<br>      docker_image_tag  = string<br>      documentation_url = string<br>    }))<br><br>    cron_schedule = optional(string, "manual")<br>    cron_timezone = optional(string, "UTC")<br><br>    normalize = optional(bool, true)<br><br>    tables_to_sync = map(object({<br>      sync_mode             = optional(string, "full_refresh")<br>      destination_sync_mode = optional(string, "append")<br>      cursor_field          = optional(string)<br>      primary_key           = optional(string)<br>    }))<br><br>    source_specification = map(string)<br><br>    destination_specification = object({<br>      dataset_name        = string<br>      dataset_location    = string<br>      staging_bucket_name = string<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id in which the existing Airbyte instance resides | `string` | n/a | yes |

## Outputs

No outputs.

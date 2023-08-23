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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~>4.75 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_airbyte_flows"></a> [airbyte\_flows](#module\_airbyte\_flows) | artefactory/airbyte-flows/google | ~> 0 |

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.pokemon_dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_dataset_iam_member.editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_member) | resource |
| [google_storage_bucket.pokemon_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

No inputs.

## Outputs

No outputs.

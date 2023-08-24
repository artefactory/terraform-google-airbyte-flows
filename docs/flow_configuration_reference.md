When calling the module, you will need to specify a `flow_configuration`. This page documents this structure.

```hcl
module "airbyte_flows" {
  source  = "artefactory/airbyte-flows/google"
  version = "~> 0"

  project_id                    = local.project_id
  airbyte_service_account_email = local.airbyte_service_account

  flows_configuration = {}  # <-- This right here
}
```

## Full specification

```hcl
map(object({
  flow_name   = string  # Display name for your data flow
  source_name = string  # Name of the source. Either one from https://docs.airbyte.com/category/sources or a custom one.
  
  custom_source = optional(object({  # Default: null. If source_name is not in the Airbyte sources catalog, you need to specify where to find it
    docker_repository = string       # Docker Repository URL (e.g. 112233445566.dkr.ecr.us-east-1.amazonaws.com/source-custom) or DockerHub identifier (e.g. airbyte/source-postgres)
    docker_image_tag  = string       # Docker image tag
    documentation_url = string       # Custom source documentation URL
  }))
  
  cron_schedule = optional(string, "manual")  # Default: manual. Cron expression for when syncs should run (ex. "0 0 12 * * ?" =\> Will sync at 12:00 PM every day)
  cron_timezone = optional(string, "UTC")     # Default: UTC. One of the TZ identifiers at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  
  normalize = optional(bool, true)  # Default: true. Whether Airbyte should normalize the data after ingestion. https://docs.airbyte.com/understanding-airbyte/basic-normalization/
  
  tables_to_sync = map(object({                               # All streams to extract from the source and load to BigQuery
    sync_mode             = optional(string, "full_refresh")  # Allowed: full_refresh | incremental. Default: full_refresh
    destination_sync_mode = optional(string, "append")        # Allowed: append | overwrite | append_dedup. Default: append
    cursor_field          = optional(string)                  # Path to the field that will be used to determine if a record is new or modified since the last sync. This field is REQUIRED if sync_mode is incremental. Otherwise it is ignored.
    primary_key           = optional(string)                  # List of the fields that will be used as primary key (multiple fields can be listed for a composite PK). This field is REQUIRED if destination_sync_mode is *_dedup. Otherwise it is ignored.
  }))
  
  source_specification = map(string)  # Source-specific configurations. Refer to the connectors catalog for more info. For any string like "secret:\<secret_name\>", the module will fetch the value of `secret_name` in the Secret Manager.
  
  destination_specification = object({
    dataset_name        = string        # Existing dataset to which your data will be written
    dataset_location    = string        # Allowed: EU | US | Any valid BQ region as specified here https://cloud.google.com/bigquery/docs/locations
    staging_bucket_name = string        # Existing bucket in which your data will be written as avro files at each connection run.
  })
}))
```

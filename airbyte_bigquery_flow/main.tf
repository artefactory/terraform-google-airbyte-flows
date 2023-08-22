resource "google_storage_hmac_key" "hmac_key" {
  project               = var.project_id
  service_account_email = var.airbyte_service_account_email
}

data "google_secret_manager_secret_version" "source_configuration_secret" {
  for_each = {
    for key, value in var.flow_configuration.source_specification :
    key => replace(value, "secret:", "") if length(regexall("secret:", value)) > 0
  }
  project = var.project_id
  secret  = each.value
}

locals {
  rendered_source_specification = {
    for key, value in var.flow_configuration.source_specification :
    key => length(regexall("secret:", value)) > 0 ? data.google_secret_manager_secret_version.source_configuration_secret[key].secret_data : value
  }
}

resource "airbyte_source_definition" "custom_source" {
  count             = var.flow_configuration.custom_source == null ? 0 : 1
  workspace_id      = var.airbyte_workspace
  name              = var.flow_configuration.source_name
  docker_repository = var.flow_configuration.custom_source.docker_repository
  docker_image_tag  = var.flow_configuration.custom_source.docker_image_tag
  documentation_url = var.flow_configuration.custom_source.documentation_url
}

resource "airbyte_source" "source" {
  workspace_id             = var.airbyte_workspace
  definition_id            = var.flow_configuration.custom_source == null ? var.flow_configuration.source_catalog_entry.0.sourceDefinitionId : airbyte_source_definition.custom_source.0.id
  name                     = var.flow_configuration.flow_name
  connection_configuration = jsonencode(local.rendered_source_specification)
}

resource "airbyte_destination" "bigquery_destination" {
  workspace_id  = var.airbyte_workspace
  definition_id = "22f6c74f-5699-40ff-833c-4a879ea40133"
  name          = var.flow_configuration.flow_name
  connection_configuration = jsonencode({
    dataset_id = var.flow_configuration.destination_specification.dataset_name
    project_id = var.project_id
    loading_method = {
      method = "GCS Staging"
      credential = {
        credential_type    = "HMAC_KEY"
        hmac_key_secret    = google_storage_hmac_key.hmac_key.secret
        hmac_key_access_id = google_storage_hmac_key.hmac_key.access_id
      }
      gcs_bucket_name          = var.flow_configuration.destination_specification.staging_bucket_name
      gcs_bucket_path          = "data_sync"
      keep_files_in_gcs-bucket = "Keep all tmp files in GCS"
    }
    dataset_location                = var.flow_configuration.destination_specification.dataset_location
    transformation_priority         = "interactive"
    big_query_client_buffer_size_mb = 15
  })
}

data "airbyte_source_schema_catalog" "source_schema_catalog" {
  source_id = airbyte_source.source.id
}

locals {
  streams = {
    for key, value in data.airbyte_source_schema_catalog.source_schema_catalog.sync_catalog :
    value.destination_config.alias_name =>
    value if contains(keys(var.flow_configuration.tables_to_sync), value.destination_config.alias_name)
  }
}

resource "airbyte_connection" "connection" {
  name           = var.flow_configuration.flow_name
  source_id      = airbyte_source.source.id
  destination_id = airbyte_destination.bigquery_destination.id
  status         = "active"

  sync_catalog = [
    for name, stream in local.streams : {
      source_schema : stream.source_schema,
      destination_config : merge(
        stream.destination_config,
        {
          selected              = true,
          destination_sync_mode = var.flow_configuration.tables_to_sync[name].destination_sync_mode,
          sync_mode             = var.flow_configuration.tables_to_sync[name].sync_mode
        }
      )
    }
  ]

  schedule_type = var.flow_configuration.cron_schedule == "manual" ? "manual" : "cron"
  cron_schedule = var.flow_configuration.cron_schedule == "manual" ? null : {
    cron_expression = var.flow_configuration.cron_schedule
    cron_time_zone  = var.flow_configuration.cron_timezone
  }

  resource_requirements = {
    cpu_limit    = "0.5"
    memory_limit = "500Mi"
  }

  operation_ids = var.flow_configuration.normalize ? [airbyte_operation.normalization.0.id] : []
}

resource "airbyte_operation" "normalization" {
  count                = var.flow_configuration.normalize ? 1 : 0
  workspace_id         = var.airbyte_workspace
  name                 = "normalization_operation"
  operator_type        = "normalization"
  normalization_option = "basic"
}

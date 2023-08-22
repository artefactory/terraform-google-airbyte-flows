variable "project_id" {
  type        = string
  description = "GCP project id in which the existing Airbyte instance resides"
}

variable "airbyte_service_account_email" {
  type        = string
  description = "Email address of the service account used by Airbyte"
}


variable "flow_configuration" {
  type = object({

    flow_name   = string # blah blah
    source_name = string

    custom_source = optional(object({
      docker_repository = string
      docker_image_tag  = string
      documentation_url = string
    }))

    cron_schedule = optional(string, "manual")
    cron_timezone = optional(string, "UTC")

    normalize = optional(bool, true)

    tables_to_sync = map(object({
      sync_mode             = optional(string, "full_refresh")
      destination_sync_mode = optional(string, "append")
      cursor_field          = optional(string)
      primary_key           = optional(string)
    }))

    source_specification = map(string)

    destination_specification = object({
      dataset_name        = string
      dataset_location    = string
      staging_bucket_name = string
    })

    source_catalog_entry = list(object({
      sourceDefinitionId = string
      spec = object({
        connectionSpecification = object({
          required = list(string)
        })
      })
    }))
  })

  # Asserts that `source_name` is an actual Airbyte source. If a custom source is specified, nothing happens.
  validation {
    condition     = length(var.flow_configuration.source_catalog_entry) != 0 || var.flow_configuration.custom_source != null
    error_message = join("", ["Source \"", var.flow_configuration.source_name, "\" not found in the Airbyte registry. Consult this page to view the list of valid connector names: https://connectors.airbyte.com/files/generated_reports/connector_registry_report.html"])
  }

  # Asserts that all required source specifications are provided with values.
  validation {
    # Suppress this validation if the one above fails to avoid extra error messages when trying to access elements in the empty source_catalog_entry
    condition = length(var.flow_configuration.source_catalog_entry) == 0 ? true : alltrue([for key in var.flow_configuration.source_catalog_entry[0].spec.connectionSpecification.required : contains(keys(var.flow_configuration.source_specification), key)])

    # Example: Missing required configuration fields in flow "Everwin Bigquery" for source "Oracle db": host, port, username
    error_message = length(var.flow_configuration.source_catalog_entry) == 0 ? "" : join("", concat(
      ["Missing required configuration fields in flow \""],
      [var.flow_configuration.flow_name],
      ["\" for source \"", var.flow_configuration.source_name, "\": "],
      [join(", ", [for key in var.flow_configuration.source_catalog_entry[0].spec.connectionSpecification.required : key if !contains(keys(var.flow_configuration.source_specification), key)]
    )]))
  }

  description = "Source -> BigQuery Airbyte flow configuration. Supports all of the Airbyte catalog sources"
}

variable "project_id" {
  type        = string
  description = "GCP project id in which the existing Airbyte instance resides"
}

variable "airbyte_workspace" {
  type        = string
  description = "Airbyte workspace ID"
}

variable "airbyte_service_account_email" {
  type        = string
  description = "Email address of the service account used by Airbyte"
}

variable "flows_configuration" {
  type = map(object({
    flow_name   = string
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
  }))
}
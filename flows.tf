data "http" "connectors_catalog" {
  url = "https://connectors.airbyte.com/files/registries/v0/oss_registry.json"
}

module "airbyte_bigquery_flow" {
  source   = "./airbyte_bigquery_flow"
  for_each = var.flows_configuration

  project_id                    = var.project_id
  airbyte_service_account_email = var.airbyte_service_account_email


  flow_configuration = merge(
    each.value,
    {
      source_catalog_entry = [
        for source in jsondecode(data.http.connectors_catalog.response_body).sources :
        source if lower(source.name) == lower(each.value.source_name)
      ]
    }
  )
}

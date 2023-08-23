# terraform-google-airbyte-flows

A Terraform module to programmatically deploy end-to-end ELT flows to BigQuery on Airbyte.
Supports custom sources and integrates with the secret manager to securely store sensitive configurations. Also allows you to specify flows as YAML.

## Prerequisites

- An up and running Airbyte instance on GCP
  - [Deploy Airbyte on compute engine](https://docs.airbyte.com/deploying-airbyte/on-gcp-compute-engine/)
  - [Deploy Airbyte on Kubernetes using Helm](https://docs.airbyte.com/deploying-airbyte/on-kubernetes-via-helm)

## Usage

### [Basic configuration example](./examples/basic/basic\_flows.tf)

Get started with the module through a minimal flow example.

### [Configuration example with secrets](./examples/secret/flows\_with\_secrets.tf)

Most sources need to be configured with secrets (DB passwords, API keys, tokens, etc...). This example shows how to configure the module to fetch secret values from the GCP secret manager to avoid hard coding them in your configuration.

### [Configuration example for a custom source](./examples/custom\_source/custom\_source\_flows.tf)

If the source you want to integrate is not in the Airbyte catalog, you can [create a custom connector](https://docs.airbyte.com/connector-development/) and use it in the module.

### [YAML configuration example](./examples/yaml/yaml\_defined\_flows.tf)

This module is designed to be compatible with external YAML configuration files. It is a convenient way for users not proficient in Terraform to specify/modify ELT pipelines programmatically, or to integrate this module with other tools that can generate YAML files.

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
| <a name="module_airbyte_bigquery_flow"></a> [airbyte\_bigquery\_flow](#module\_airbyte\_bigquery\_flow) | ./airbyte_bigquery_flow | n/a |

## Resources

| Name | Type |
|------|------|
| [http_http.connectors_catalog](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airbyte_service_account_email"></a> [airbyte\_service\_account\_email](#input\_airbyte\_service\_account\_email) | Email address of the service account used by the Airbyte VM | `string` | n/a | yes |
| <a name="input_flows_configuration"></a> [flows\_configuration](#input\_flows\_configuration) | Definition of all the flows to Bigquery that will be Terraformed to your Airbyte instance | <pre>map(object({<br>    flow_name   = string<br>    source_name = string<br><br>    custom_source = optional(object({<br>      docker_repository = string<br>      docker_image_tag  = string<br>      documentation_url = string<br>    }))<br><br>    cron_schedule = optional(string, "manual")<br>    cron_timezone = optional(string, "UTC")<br><br>    normalize = optional(bool, true)<br><br>    tables_to_sync = map(object({<br>      sync_mode             = optional(string, "full_refresh")<br>      destination_sync_mode = optional(string, "append")<br>      cursor_field          = optional(string)<br>      primary_key           = optional(string)<br>    }))<br><br>    source_specification = map(string)<br><br>    destination_specification = object({<br>      dataset_name        = string<br>      dataset_location    = string<br>      staging_bucket_name = string<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id in which the existing Airbyte instance resides | `string` | n/a | yes |

## Outputs

No outputs.

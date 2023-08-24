/*
* # terraform-google-airbyte-flows
*
* A Terraform module to programmatically deploy end-to-end ELT flows to BigQuery on Airbyte.
* Supports custom sources and integrates with the secret manager to securely store sensitive configurations. Also allows you to specify flows as YAML.
*
* ## Prerequisites
*
* - An up and running Airbyte instance on GCP
*   - [Deploy Airbyte on compute engine](https://docs.airbyte.com/deploying-airbyte/on-gcp-compute-engine/)
*   - [Deploy Airbyte on Kubernetes using Helm](https://docs.airbyte.com/deploying-airbyte/on-kubernetes-via-helm)
*
* ## Usage
*
* ### [Basic configuration example](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/basic/basic_flows.tf)
*
* Get started with the module through a minimal flow example.
*
* ### [Configuration example with secrets](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/secret/flows_with_secrets.tf)
*
* Most sources need to be configured with secrets (DB passwords, API keys, tokens, etc...). This example shows how to configure the module to fetch secret values from the GCP secret manager to avoid hard coding them in your configuration.
*
* ### [Configuration example for a custom source](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/custom_source/custom_source_flows.tf)
*
* If the source you want to integrate is not in the Airbyte catalog, you can [create a custom connector](https://docs.airbyte.com/connector-development/) and use it in the module.
*
* ### [Scheduled flow configuration example](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/scheduled_flow/scheduled_flows.tf.tf)
*
* You can set your ELT pipelines to run on a cron schedule by setting `cron_schedule` and optionally `cron_timezone`.
*
* ### [YAML configuration example](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/yaml/yaml_defined_flows.tf)
*
* This module is designed to be compatible with external YAML configuration files. It is a convenient way for users not proficient in Terraform to specify/modify ELT pipelines programmatically, or to integrate this module with other tools that can generate YAML files.
*
*/
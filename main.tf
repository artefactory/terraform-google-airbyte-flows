/*
* # terraform-google-airbyte-flows
* A Terraform module to programmatically deploy end-to-end ELT flows to BigQuery on Airbyte.
*
* ## Prerequisites
*
* - An up and running Airbyte instance on GCP
*   - [Deploy Airbyte on compute engine](https://docs.airbyte.com/deploying-airbyte/on-gcp-compute-engine/)
*   - [Deploy Airbyte on Kubernetes using Helm](https://docs.airbyte.com/deploying-airbyte/on-kubernetes-via-helm)
*
* ## Usage
*
* ### [Basic configuration example](./examples/basic/main.tf)
*
* Get started with the module through a minimal flow example.
*
* ### [Configuration example with secrets](./examples/basic/main.tf)
*
* Most sources need to be configured with secrets (DB passwords, API keys, tokens, etc...). This example shows how to configure the module to fetch secret values from the GCP secret manager to avoid hard coding them in your configuration.
*
* ### [YAML configuration example](./examples/yaml/main.tf)
*
* This module is designed to be compatible with external YAML configuration files. It is a convenient way for users not proficient in Terraform to specify/modify ELT pipelines programmatically, or to integrate this module with other tools that can generate YAML files.
*
*/
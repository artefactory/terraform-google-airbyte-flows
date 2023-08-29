/*
* # terraform-google-airbyte-flows
*
* A Terraform module to programmatically deploy end-to-end ELT flows to BigQuery on Airbyte.
* Supports custom sources and integrates with the secret manager to securely store sensitive configurations. Also allows you to specify flows as YAML.
*
* ## Prerequisites
*
* - Terraform. Tested with v1.5.3. [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* - An authenticated gcloud CLI
*   - [Install the gcloud CLI](https://cloud.google.com/sdk/docs/install)
*   - `gcloud init`
*   - `gcloud auth application-default login`
* - An up and running Airbyte instance on GCP
*   - [Deploy Airbyte using the airbyte-infra Terraform module](https://github.com/artefactory/terraform-google-airbyte-infra) or
*   - [Deploy Airbyte on compute engine](https://docs.airbyte.com/deploying-airbyte/on-gcp-compute-engine/) or
*   - [Deploy Airbyte on Kubernetes using Helm](https://docs.airbyte.com/deploying-airbyte/on-kubernetes-via-helm)
* - GCP permissions
*     - Broad roles that will work, but **not recommended** for service accounts or even people.
*       - `roles/owner`
*       - `roles/editor`
*     - Recommended roles to respect the least privilege principle.
*       - `roles/bigquery.dataOwner`
*       - `roles/secretmanager.admin`
*       - `roles/storage.admin`
*     - Granular permissions required to build a custom role specific for this deployment.
*       - `bigquery.datasets.create`
*       - `bigquery.datasets.delete`
*       - `bigquery.datasets.update`
*       - `secretmanager.secrets.create`
*       - `secretmanager.secrets.delete`
*       - `secretmanager.versions.add`
*       - `secretmanager.versions.destroy`
*       - `secretmanager.versions.enable`
*       - `storage.buckets.create`
*       - `storage.buckets.delete`
*       - `storage.buckets.getIamPolicy`
*       - `storage.buckets.setIamPolicy`
*       - `storage.hmacKeys.create`
*       - `storage.hmacKeys.delete`
*       - `storage.hmacKeys.update`
*
* ## Usage
*
* [Go to the `examples` directory to view all the code samples.](https://github.com/artefactory/terraform-google-airbyte-flows/tree/main/examples)
*
* ---
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
* ## Features
*
* ### Programmatic deployment of ELT flow to BigQuery with minimal configuration
*
* The module is highly opinionated to reduce the design load of the users. In a few minutes/hours, you should be able to build data flows from your sources to BigQuery.
*
* Deploying through Terraform rather than the Airbyte UI will allow you to benefit from all the advantages of config-based deployments.
*
* - Easier and less error-prone to upgrade environments.
* - Automatable in a CI/CD for better saclability, consistency, and efficiency.
* - All the configuration is centralized and versioned in git for reviews and tests.
*
*
* ### Seamless integration with the secret manager to secure sensitive configurations
*
* Most of the sources will require to be set up with sensitive information such as API keys, database password, and other secrets. In order not to have these as clear text on your repo, this module integrates with the secret manager to fetch sensitive data at deployment time.
*
* ### Custom sources support
*
* Airbyte has a lot of sources, but in the event yours is not officially supported, you can create your own and this module will be able to use it.
*
*
* ### YAML-compatible configuration
*
* Even though this module is likely to only be used by data engineers who are proficient with Terraform, it might be useful to de-couple the ELT configuration details from the TF code through a YAML file.
*
* - Users who don't know Terraform can update the config files themselves more easily.
* - It becomes possible to have a front or form that generates theses YAML files to then be automatically deployed by Terraform.
* - It separates concerns and avoids super long terraform files if you have alot of flows.
*
* ### Out of the box data staging in GCS
*
* Under the hood, the data going from your sources through Airbyte and to BigQuery will always be staged in a GCS bucket as Avro files. This is important for disaster recovery, reprocessings, backfills, archival, compliance, etc...
*
* ### Input validation for sources configurations
*
* A lot of attention was given to provide useful error messages when you misconfigure a source. If you're stuck, make sure to refer to the [Airbyte connector catalog](https://docs.airbyte.com/category/sources), or to [the full connectors spec](https://connectors.airbyte.com/files/registries/v0/oss_registry.json) to check what your source requires.
*
*
* ## Limitations
*
* As this module depends on an available Airbyte deployment at plan time, it can not live in the same terraform state as the Airbyte infrastructure deployment itself. You will first need to deploy the Airbyte VM/cluster, and then the ELT flows separately.
*
* It is very difficult to use from TF Cloud. You would either need to expose the Airbyte instance to the public internet, or find a way to create an SSH tunnel to it from the TF Cloud runner. If you find a neat way to work around this issue, hit me up at alexis.vialaret@artefact.com.
*
* ## Reference: `flows_configuration`
*
* When calling the module, you will need to specify a `flow_configuration`. This page documents this structure.
*
* ```hcl
* module "airbyte_flows" {
*   source  = "artefactory/airbyte-flows/google"
*   version = "~> 0"
*
*   project_id                    = local.project_id
*   airbyte_service_account_email = local.airbyte_service_account
*
*   flows_configuration = {}  # <-- This right here
* }
* ```
*
* ### Full specification
*
* ```hcl
* map(object({
*   flow_name   = string  # Display name for your data flow
*   source_name = string  # Name of the source. Either one from https://docs.airbyte.com/category/sources or a custom one.
*
*   custom_source = optional(object({  # Default: null. If source_name is not in the Airbyte sources catalog, you need to specify where to find it
*     docker_repository = string       # Docker Repository URL (e.g. 112233445566.dkr.ecr.us-east-1.amazonaws.com/source-custom) or DockerHub identifier (e.g. airbyte/source-postgres)
*     docker_image_tag  = string       # Docker image tag
*     documentation_url = string       # Custom source documentation URL
*   }))
*
*   cron_schedule = optional(string, "manual")  # Default: manual. Cron expression for when syncs should run (ex. "0 0 12 * * ?" =\> Will sync at 12:00 PM every day)
*   cron_timezone = optional(string, "UTC")     # Default: UTC. One of the TZ identifiers at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
*
*   normalize = optional(bool, true)  # Default: true. Whether Airbyte should normalize the data after ingestion. https://docs.airbyte.com/understanding-airbyte/basic-normalization/
*
*   tables_to_sync = map(object({                               # All streams to extract from the source and load to BigQuery
*     sync_mode             = optional(string, "full_refresh")  # Allowed: full_refresh | incremental. Default: full_refresh
*     destination_sync_mode = optional(string, "append")        # Allowed: append | overwrite | append_dedup. Default: append
*     cursor_field          = optional(string)                  # Path to the field that will be used to determine if a record is new or modified since the last sync. This field is REQUIRED if sync_mode is incremental. Otherwise it is ignored.
*     primary_key           = optional(string)                  # List of the fields that will be used as primary key (multiple fields can be listed for a composite PK). This field is REQUIRED if destination_sync_mode is *_dedup. Otherwise it is ignored.
*   }))
*
*   source_specification = map(string)  # Source-specific configurations. Refer to the connectors catalog for more info. For any string like "secret:\<secret_name\>", the module will fetch the value of `secret_name` in the Secret Manager.
*
*   destination_specification = object({
*     dataset_name        = string        # Existing dataset to which your data will be written
*     dataset_location    = string        # Allowed: EU | US | Any valid BQ region as specified here https://cloud.google.com/bigquery/docs/locations
*     staging_bucket_name = string        # Existing bucket in which your data will be written as avro files at each connection run.
*   })
* }))
* ```
*
* ---
* ## Auto-generated module documentation
*/
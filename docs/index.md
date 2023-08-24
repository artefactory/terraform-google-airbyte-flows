This module will help you programmatically deploy end-to-end ELT flows to BigQuery on Airbyte.

It supports custom sources and integrates with the secret manager to securely store sensitive configurations. Also allows you to specify flows as YAML.

---
[View the module in the Terraform registry](https://registry.terraform.io/modules/artefactory/airbyte-flows/google/latest)

[View the module in GitHub](https://github.com/artefactory/terraform-google-airbyte-flows)

---
## Pre-requisites

??? success "Install Terraform"

    !!! note
        Tested for Terraform >= v1.4.0

    Use tfswitch to easily install and manage Terraform versions:
    ```console
    $ brew install warrensbox/tap/tfswitch
    
    [...]
    ==> Summary
    🍺  /opt/homebrew/Cellar/tfswitch/0.13.1308: 6 files, 10.1MB, built in 3 seconds
    ==> Running `brew cleanup tfswitch`...
    ```
    ```console
    $ tfswitch
    
    ✔ 1.4.2
    Downloading to: /Users/alexis.vialaret/.terraform.versions
    20588400 bytes downloaded
    Switched terraform to version "1.4.2" 
    ```
  

??? success "Log in to GCP with your default credentials"

    !!! warning 
        Look at the below commands outputs to make sure you're connecting to the right `PROJECT_ID`.
  
    ```console
    gcloud auth login
    
    [...]
    You are now logged in as [alexis.vialaret@artefact.com].
    Your current project is [PROJECT_ID]. You can change this setting by running:
    $ gcloud config set project PROJECT_ID
    ```
    
    ```console
    gcloud auth application-default login

    [...]
    Credentials saved to file: [/Users/alexis.vialaret/.config/gcloud/application_default_credentials.json]
    These credentials will be used by any library that requests Application Default Credentials (ADC).
    Quota project "PROJECT_ID" was added to ADC which can be used by Google client libraries for billing and quota. Note that some services may still bill the project owning the resource.
    ```

??? success "Deploy an Airbyte instance on your project"

    - [Deploy Airbyte on compute engine](https://docs.airbyte.com/deploying-airbyte/on-gcp-compute-engine)

    - [Deploy Airbyte on Kubernetes using Helm](https://docs.airbyte.com/deploying-airbyte/on-kubernetes-via-helm)

    Make sure Terraform will be able to access your instance. 
    
    If you deployed Airbyte on a VM, and want to Terraform it from your local machine you can tunnel through SSH with this command:
    ```shell
    gcloud --project=<GCP_PROJECT_ID> compute ssh <AIRBYTE_VM_NAME> -- -L 8000:localhost:8000 -N -f
    ```
    Test that it worked by going to http://localhost:8000/ in your browser.
    
    [Then, set up the Airbyte TF provider](https://registry.terraform.io/providers/josephjohncox/airbyte/latest/docs):
    ```hcl
    provider "airbyte" {
      host_url = "http://localhost:8000"
      username = "airbyte"  # If you deployed airbyte with a different username/password, change the default values here.
      password = "password" 
      additional_headers = {
        Host = "airbyte.internal"
      }
    }
    ```

??? success "Required roles and permissions"
    
    - Broad roles that will work, but **not recommended** for service accounts or even people.
      - `roles/owner`
      - `roles/editor`
    - Recommended roles to respect the least privilege principle.
      - `roles/bigquery.dataOwner`
      - `roles/secretmanager.admin`
      - `roles/storage.admin`
    - Granular permissions required to build a custom role specific for this deployment.
      - `bigquery.datasets.create`
      - `bigquery.datasets.delete`
      - `bigquery.datasets.update`
      - `secretmanager.secrets.create`
      - `secretmanager.secrets.delete`
      - `secretmanager.versions.add`
      - `secretmanager.versions.destroy`
      - `secretmanager.versions.enable`
      - `storage.buckets.create`
      - `storage.buckets.delete`
      - `storage.buckets.getIamPolicy`
      - `storage.buckets.setIamPolicy`
      - `storage.hmacKeys.create`
      - `storage.hmacKeys.delete`
      - `storage.hmacKeys.update`

---
## Features
    
??? success "Programmatically deploy ELT flow to BigQuery with minimal configuration"
    
    The module is highly opinionated to reduce the design load of the users. In a few minutes/hours, you should be able to build data flows from your sources to BigQuery.

    Deploying through Terraform rather than the Airbyte UI will allow you to benefit from all the advantages of config-based deployments. 
        
    - Easier and less error-prone to upgrade environments.
    - Automatable in a CI/CD for better saclability, consistency, and efficiency.
    - All the configuration is centralized and versioned in git for reviews and tests.


??? success "Seamless integration with the secret manager to secure sensitive configurations"
    
    Most of the sources will require to be set up with sensitive information such as API keys, database password, and other secrets. In order not to have these as clear text on your repo, this module integrates with the secret manager to fetch sensitive data at deployment time.

    [Data flow with secrets example here](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/secret/flows_with_secrets.tf)

??? success "Supports custom sources"
    
    Airbyte has a lot of sources, but in the event yours is not officially supported, you can create your own and this module will be able to use it.

    [Custom source data flows example here](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/custom_source/custom_source_flows.tf)

??? success "Abstract away the Terraform complexity by providing YAML configurations"

    Even though this module is likely to only be used by data engineers who are proficient with Terraform, it might be useful to de-couple the ELT configuration details from the TF code through a YAML file.

    - Users who don't know Terraform can update the config files themselves more easily.
    - It becomes possible to have a front or form that generates theses YAML files to then be automatically deployed by Terraform.
    - It separates concerns and avoids super long terraform files if you have alot of flows.

    [YAML-defined data flow example here](https://github.com/artefactory/terraform-google-airbyte-flows/blob/main/examples/yaml/yaml_defined_flows.tf)

??? success "Out of the box data staging in GCS"
    
    Under the hood, the data going from your sources through Airbyte and to BigQuery will always be staged in a GCS bucket as Avro files. This is important for disaster recovery, reprocessings, backfills, archival, compliance, etc...

??? success "Input validation for sources configurations"
    
    A lot of attention was given to provide useful error messages when you misconfigure a source. If you're stuck, make sure to refer to the [Airbyte connector catalog](https://docs.airbyte.com/category/sources), or to [the full connectors spec](https://connectors.airbyte.com/files/registries/v0/oss_registry.json) to check what your source requires.

---
## Deploy Airbyte flows using this module

[Refer to the code samples here to get started deploying ELT flows](https://github.com/artefactory/terraform-google-airbyte-flows/tree/main/examples)

---
## Limitations

- As this module depends on an available Airbyte deployment at plan time, it can not live in the same terraform state as the Airbyte infrastructure deployment itself. You will first need to deploy the Airbyte VM/cluster, and then the ELT flows separately.
- It is very difficult to use from TF Cloud. You would either need to expose the Airbyte instance to the public internet, or find a way to create an SSH tunnel to it from the TF Cloud runner. If you find a neat way to work around this issue, hit me up at alexis.vialaret@artefact.com.
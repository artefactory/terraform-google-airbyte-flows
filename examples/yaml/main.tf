terraform {
  required_providers {
    airbyte = {
      source  = "josephjohncox/airbyte"
      version = "~>0.1"
    }
  }
}

provider "airbyte" {
  host_url = "http://localhost:8000"
  username = "airbyte"
  password = "password"
  additional_headers = {
    Host = "airbyte.internal"
  }
}

resource "airbyte_workspace" "main" {
  name = "main_workspace"
}

module "airbyte_flows" {
  source  = "artefactory/airbyte-flows/google"
  version = "~> 0"

  project_id                    = "<GCP_PROJECT_ID>"
  airbyte_service_account_email = "<AIRBYTE_INSTANCE_SERVICE_ACCOUNT_EMAIL>"
  airbyte_workspace             = airbyte_workspace.main.id

  flows_configuration = yamldecode(file("./flows.yaml"))
}
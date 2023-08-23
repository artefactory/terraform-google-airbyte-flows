#################################
# CREATE A SECRET CONFIGURATION #
#################################

# This is useful for connectors that need API keys, DB password, etc.
# Here "charizard" is our secret value.
# It is created here to have a working example, but don't actually store them as clear text in your Git.

resource "google_secret_manager_secret" "secret_pokemon" {
  secret_id = "pokemon_name"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_pokemon_version" {
  secret      = google_secret_manager_secret.secret_pokemon.id
  secret_data = "charizard"
}

# Before applying this configuration, you will first need to deploy an Airbyte on Google Compute Engine: https://docs.airbyte.com/deploying-airbyte/on-gcp-compute-engine/
# Then create a SSH connection to the VM where your Airbyte instance is deployed:
# `gcloud --project=<GCP_PROJECT_ID> compute ssh <AIRBYTE_VM_NAME> -- -L 8000:localhost:8000 -N -f`

locals {
  project_id = "<GCP_PROJECT_ID>"

  # Service account used by your Airbyte deployment
  airbyte_service_account = "<AIRBYTE_VM_SERVICE_ACCOUNT_EMAIL>"

  # GCS bucket that will be created. Data will be staged here as avro files for disaster recovery, reprocessing, backfills, archival, etc
  staging_bucket = "<UNIQUE_BUCKET_NAME>"

  # Bigquery dataset that will be created for your data to land in
  destination_dataset = "pokemon_dataset"

  # Where the data will be located on GCS and BQ
  data_location = "EU"
}

module "airbyte_flows" {
  source  = "artefactory/airbyte-flows/google"
  version = "~> 0"

  project_id                    = local.project_id
  airbyte_service_account_email = local.airbyte_service_account

  flows_configuration = {
    pokeapi_to_bigquery = {
      flow_name   = "PokeAPI to bigquery"
      source_name = "PokeAPI"

      tables_to_sync = {
        pokemon = {
          sync_mode             = "full_refresh"
          destination_sync_mode = "overwrite"
        }
      }

      source_specification = {
        pokemon_name = "secret:pokemon_name" # use this "secret:<secret_name>" name to tell the module to fetch the secret value.
      }

      destination_specification = {
        dataset_name        = google_bigquery_dataset.pokemon_dataset.dataset_id
        dataset_location    = google_bigquery_dataset.pokemon_dataset.location
        staging_bucket_name = google_storage_bucket.pokemon_bucket.name
      }
    }
  }
  depends_on = [google_secret_manager_secret_version.secret_pokemon_version]
}

#################################
# CONFIGURE TERRAFORM PROVIDERS #
#################################
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.75"
    }
    airbyte = {
      source  = "josephjohncox/airbyte"
      version = "~>0.1"
    }
  }
}

provider "google" {
  project = local.project_id
}

provider "airbyte" {
  host_url = "http://localhost:8000"
  username = "airbyte"
  password = "password"
  additional_headers = {
    Host = "airbyte.internal"
  }
}


################################################################
# CREATE GCS STAGING BUCKET AND AUTHORIZE AIRBYTE TO ACCESS IT #
################################################################
resource "google_storage_bucket" "pokemon_bucket" {
  name     = local.staging_bucket
  location = local.data_location
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.pokemon_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${local.airbyte_service_account}"
}

##############################################################
# CREATE BIGQUERY DATASET AND AUTHORIZE AIRBYTE TO ACCESS IT #
##############################################################
resource "google_bigquery_dataset" "pokemon_dataset" {
  dataset_id = local.destination_dataset
  location   = local.data_location
}

resource "google_bigquery_dataset_iam_member" "editor" {
  dataset_id = google_bigquery_dataset.pokemon_dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${local.airbyte_service_account}"
}

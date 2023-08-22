terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.75"
    }
    http = {
      source  = "hashicorp/http"
      version = "~>3.4"
    }
    airbyte = {
      source  = "josephjohncox/airbyte"
      version = "~>0.1"
    }
  }
}

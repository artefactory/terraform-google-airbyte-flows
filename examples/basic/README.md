This is a minimal example of how to use this module to deploy an Airbyte flow from the PokeAPI to Bigquery.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_airbyte"></a> [airbyte](#requirement\_airbyte) | ~>0.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>4.75 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~>4.75 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_airbyte_flows"></a> [airbyte\_flows](#module\_airbyte\_flows) | artefactory/airbyte-flows/google | ~> 0 |

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.pokemon_dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_dataset_iam_member.editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_member) | resource |
| [google_storage_bucket.pokemon_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

No inputs.

## Outputs

No outputs.

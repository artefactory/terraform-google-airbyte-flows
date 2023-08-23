Most sources need to be configured with secrets (DB passwords, API keys, tokens, etc...). This example shows how to configure the module to fetch secret values from the GCP secret manager to avoid hard coding them in your configuration.

You will first need to create a secret with your sensitive value, for example we create a secret named `pokemon_name`, with the value `charizard`.

```shell
$ gcloud secrets create pokemon_name --replication-policy="automatic"
$ echo -n "charizard" | gcloud secrets versions add pokemon_name --data-file=-
```

Then in your Terraform configuration, in `source_specification`, tell the module to fetch a secret value like so:
```hcl
source_specification = {
    pokemon_name = "secret:pokemon_name" # use this "secret:<secret_name>" name to tell the module to fetch the secret value.
}
```

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
| [google_secret_manager_secret.secret_pokemon](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.secret_pokemon_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_storage_bucket.pokemon_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

No inputs.

## Outputs

No outputs.

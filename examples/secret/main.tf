/*
* Most sources need to be configured with secrets (DB passwords, API keys, tokens, etc...). This example shows how to configure the module to fetch secret values from the GCP secret manager to avoid hard coding them in your configuration.
*
* You will first need to create a secret with your sensitive value, for example we create a secret named `pokemon_name`, with the value `charizard`.
*
* ```shell
* $ gcloud secrets create pokemon_name --replication-policy="automatic"
* $ echo -n "charizard" | gcloud secrets versions add pokemon_name --data-file=-
* ```
*
* Then in your Terraform configuration, in `source_specification`, tell the module to fetch a secret value like so:
* ```hcl
* source_specification = {
*     pokemon_name = "secret:pokemon_name" # use this "secret:<secret_name>" name to tell the module to fetch the secret value.
* }
* ```
*/
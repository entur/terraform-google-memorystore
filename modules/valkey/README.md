# Memorystore Valkey Terraform Module

Creates a Valkey instance and creates the following Google Secret Manager secrets in your GCP project:

```bash

```

## Usage

```terraform
module "valkey" {
  source = "github.com/entur/terraform-google-memorystore//modules/valkey?ref=v1"
  ...
}
```

To expose the secrets as environment variables in kubernetes, use our [common helm chart](https://github.com/entur/helm-charts/tree/main/charts/common) like this:

```yaml
common:
  ..
  ...
  .
  secrets:
    valkey-credentials:
```

<!-- BEGIN_TF_DOCS -->

!-- END_TF_DOCS -->

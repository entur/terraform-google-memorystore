# Memorystore Valkey Terraform Module

Creates a Valkey instance and creates the following Google Secret Manager secrets in your GCP project:

```bash
VALKEY_HOST
VALKEY_PORT
CA
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
    - VALKEY_HOST
    - VALKEY_PORT
    - CA
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=4.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=4.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_memorystore_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memorystore_instance) | resource |
| [google_secret_manager_secret.main_valkey_secret_credentials](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.main_valkey_secret_credentials_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version in the form VALKEY\_<major>\_<minor>. | `string` | n/a | yes |
| <a name="input_init"></a> [init](#input\_init) | Entur init module output. https://github.com/entur/terraform-gcp-init. Used to determine application name, application project, network project, labels, and resource names. | <pre>object({<br/>    app = object({<br/>      id         = string<br/>      name       = string<br/>      owner      = string<br/>      project_id = string<br/>    })<br/>    environment = string<br/>    networks = object({<br/>      project_id = string<br/>      vpc_id     = string<br/>    })<br/>    labels        = map(string)<br/>    is_production = bool<br/>  })</pre> | n/a | yes |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Whether deletion protection is enabled. Defaults to True in production, false otherwise. | `bool` | `null` | no |
| <a name="input_engine_configs"></a> [engine\_configs](#input\_engine\_configs) | The engine configuration flags. | `map(string)` | <pre>{<br/>  "maxmemory-policy": "allkeys-lfu"<br/>}</pre> | no |
| <a name="input_generation"></a> [generation](#input\_generation) | Generation of the memorystore instance. Starts at 1, ends at 999. Will be padded with leading zeros. | `number` | `1` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The day of the week (MONDAY-SUNDAY), and hour of the day (0-24) in UTC to perform database instance maintenance. This is the start time of the one hour maintenance window. | <pre>object({<br/>    day  = string<br/>    hour = number<br/>  })</pre> | <pre>{<br/>  "day": "TUESDAY",<br/>  "hour": 2<br/>}</pre> | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Cluster mode allows you to partition data between shards. | `string` | `"CLUSTER"` | no |
| <a name="input_name_override"></a> [name\_override](#input\_name\_override) | Set to override the default memorystore name. Follows contentions; setting it to 'foo' in dev will result in the memorystore being named 'mem-foo-dev-001' (<prefix>-<var.name\_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map and secret. | `string` | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The node type of the valkey instance. Options are STANDARD\_SMALL, SHARED\_CORE\_NANO, HIGHMEM\_MEDIUM, HIGHMEM\_XLARGE | `string` | `"STANDARD_SMALL"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the memorystore instance. | `string` | `"europe-west1"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | The number [0-5] of replica nodes. Defaults to 0. 0 means no read replicas, just a primary. | `number` | `0` | no |
| <a name="input_secret_key_prefix"></a> [secret\_key\_prefix](#input\_secret\_key\_prefix) | Key prefix of secret. Ex. {secret\_key\_prefix: FIRST\_} would give keys FIRST\_REDIS\_HOST, FIRST\_REDIS\_PASSWORD. Default is instance name | `string` | `""` | no |
| <a name="input_shard_count"></a> [shard\_count](#input\_shard\_count) | Number of shards, more shards is scaling the instance horizontally out. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_init"></a> [init](#output\_init) | The init module used in the module. |
| <a name="output_instance"></a> [instance](#output\_instance) | The memorystore instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memorystore_instance. |
| <a name="output_instance_connection_info"></a> [instance\_connection\_info](#output\_instance\_connection\_info) | n/a |
| <a name="output_secret_manager_secret_ids"></a> [secret\_manager\_secret\_ids](#output\_secret\_manager\_secret\_ids) | n/a |
<!-- END_TF_DOCS -->

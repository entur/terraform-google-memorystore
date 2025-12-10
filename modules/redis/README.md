# Memorystore Redis Terraform Module

Creates a Redis instance and creates the following Google Secret Manager secrets in your GCP project:

```bash
REDIS_HOST
REDIS_PORT
REDIS_PASSWORD
```

## Usage

```terraform
module "redis" {
  source = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v2"
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
    redis-credentials:
      - REDIS_HOST
      - REDIS_PORT
      - REDIS_PASSWORD
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=4.76.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=4.76.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_redis_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |
| [google_secret_manager_secret.main_redis_secret_credentials](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.main_redis_secret_credentials_version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [kubernetes_config_map.main_redis_connection](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_secret.main_redis_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_init"></a> [init](#input\_init) | Entur init module output. https://github.com/entur/terraform-gcp-init. Used to determine application name, application project, network project, labels, and resource names. | <pre>object({<br/>    app = object({<br/>      id         = string<br/>      name       = string<br/>      owner      = string<br/>      project_id = string<br/>    })<br/>    environment = string<br/>    networks = object({<br/>      project_id = string<br/>      vpc_id     = string<br/>    })<br/>    labels        = map(string)<br/>    is_production = bool<br/>  })</pre> | n/a | yes |
| <a name="input_add_redis_secret_manager_credentials"></a> [add\_redis\_secret\_manager\_credentials](#input\_add\_redis\_secret\_manager\_credentials) | Set to false to not store redis credentials in secret manager | `bool` | `true` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | REGIONAL or ZONAL database. | `string` | `"REGIONAL"` | no |
| <a name="input_create_kubernetes_resources"></a> [create\_kubernetes\_resources](#input\_create\_kubernetes\_resources) | Optionally disables creating k8s resources -redis-connection and -redis-secret. Can be used to avoid overwriting existing resources on database creation. | `bool` | `true` | no |
| <a name="input_enable_replicas"></a> [enable\_replicas](#input\_enable\_replicas) | Enable read replicas | `bool` | `false` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | Generation of the redis instance. Starts at 1, ends at 999. Will be padded with leading zeros. | `number` | `1` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The day of the week (MONDAY-SUNDAY), and hour of the day (0-24) in UTC to perform database instance maintenance. This is the start time of the one hour maintinance window. | <pre>object({<br/>    day  = string<br/>    hour = number<br/>  })</pre> | <pre>{<br/>  "day": "TUESDAY",<br/>  "hour": 0<br/>}</pre> | no |
| <a name="input_memory_size_gb"></a> [memory\_size\_gb](#input\_memory\_size\_gb) | Allocated memory capasitiy for the instance in GB. | `number` | `1` | no |
| <a name="input_name_override"></a> [name\_override](#input\_name\_override) | Set to override the default redis name. Follows contentions; setting it to 'foo' in dev will result in the redis being named 'mem-foo-dev-001' (<prefix>-<var.name\_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map and secret. | `string` | `null` | no |
| <a name="input_redis_configs"></a> [redis\_configs](#input\_redis\_configs) | The redis configuration flags. | `map(string)` | <pre>{<br/>  "activedefrag": "yes",<br/>  "maxmemory-policy": "allkeys-lfu"<br/>}</pre> | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | The redis version in the form REDIS\_7\_0. | `string` | `"REDIS_7_0"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the redis instance. | `string` | `"europe-west1"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | The number [1-5] of replica nodes. Defaults to 1. | `number` | `1` | no |
| <a name="input_secret_key_prefix"></a> [secret\_key\_prefix](#input\_secret\_key\_prefix) | Key prefix of secret. Ex. {secret\_key\_prefix: FIRST\_} would give keys FIRST\_REDIS\_HOST, FIRST\_REDIS\_PASSWORD and so on | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC network id, used for projects without a shared VPC. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_init"></a> [init](#output\_init) | The init module used in the module. |
| <a name="output_instance"></a> [instance](#output\_instance) | The redis instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance. |
| <a name="output_kubernetes_namespace"></a> [kubernetes\_namespace](#output\_kubernetes\_namespace) | Name of the kubernetes namespace where the connection details configmap is deployed. |
| <a name="output_redis_password"></a> [redis\_password](#output\_redis\_password) | The auth password used to connect to the redis instance |
| <a name="output_secret_manager_secret_ids"></a> [secret\_manager\_secret\_ids](#output\_secret\_manager\_secret\_ids) | n/a |
<!-- END_TF_DOCS -->
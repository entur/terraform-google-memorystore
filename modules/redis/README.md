# Memorystore Redis Terraform Module #

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=4.26.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=4.26.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_redis_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |
| [kubernetes_config_map.main_redis_connection](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_init"></a> [init](#input\_init) | Entur init module output. https://github.com/entur/terraform-gcp-init. Used to determine application name, application project, network project, labels, and resource names. | <pre>object({<br>    app = object({<br>      id         = string<br>      name       = string<br>      owner      = string<br>      project_id = string<br>    })<br>    environment = string<br>    networks = object({<br>      project_id = string<br>      vpc_id     = string<br>    })<br>    labels        = map(string)<br>    is_production = bool<br>  })</pre> | n/a | yes |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | REGIONAL or ZONAL database. | `string` | `"REGIONAL"` | no |
| <a name="input_enable_replicas"></a> [enable\_replicas](#input\_enable\_replicas) | Enable read replicas | `bool` | `false` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | Generation of the redis instance. Starts at 1, ends at 999. Will be padded with leading zeros. | `number` | `1` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The day of the week (MONDAY-SUNDAY), and hour of the day (0-24) in UTC to perform database instance maintenance. This is the start time of the one hour maintinance window. | <pre>object({<br>    day  = string<br>    hour = number<br>  })</pre> | <pre>{<br>  "day": "TUESDAY",<br>  "hour": 0<br>}</pre> | no |
| <a name="input_memory_size_gb"></a> [memory\_size\_gb](#input\_memory\_size\_gb) | Allocated memory capasitiy for the instance in GB. | `number` | `1` | no |
| <a name="input_redis_configs"></a> [redis\_configs](#input\_redis\_configs) | The redis configuration flags. | `map(string)` | <pre>{<br>  "activedefrag": "yes",<br>  "maxmemory-policy": "allkeys-lfu"<br>}</pre> | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | The redis version in the form REDIS\_4\_0. | `string` | `"REDIS_4_0"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the redis instance. | `string` | `"europe-west1"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | The number [1-5] of replica nodes. Defaults to 1. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_init"></a> [init](#output\_init) | The init module used in the module. |
| <a name="output_instance"></a> [instance](#output\_instance) | The redis instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance. |
| <a name="output_kubernetes_namespace"></a> [kubernetes\_namespace](#output\_kubernetes\_namespace) | Name of the kubernetes namespace where the connection details configmap is deployed. |
<!-- END_TF_DOCS -->
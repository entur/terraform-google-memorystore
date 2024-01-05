variable "init" {
  description = "Entur init module output. https://github.com/entur/terraform-gcp-init. Used to determine application name, application project, network project, labels, and resource names."
  type = object({
    app = object({
      id         = string
      name       = string
      owner      = string
      project_id = string
    })
    environment = string
    networks = object({
      project_id = string
      vpc_id     = string
    })
    labels        = map(string)
    is_production = bool
  })
}

variable "name_override" {
  description = "Set to override the default redis name. Follows contentions; setting it to 'foo' in dev will result in the redis being named 'mem-foo-dev-001' (<prefix>-<var.name_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map and secret."
  type        = string
  default     = null
}

variable "region" {
  description = "The region of the redis instance."
  type        = string
  default     = "europe-west1"
}

variable "generation" {
  description = "Generation of the redis instance. Starts at 1, ends at 999. Will be padded with leading zeros."
  type        = number
  default     = 1

  validation {
    condition     = var.generation < 1000 && var.generation > 0
    error_message = "Generation must be bewteen [1,999]."
  }
}
variable "maintenance_window" {
  description = "The day of the week (MONDAY-SUNDAY), and hour of the day (0-24) in UTC to perform database instance maintenance. This is the start time of the one hour maintinance window."
  type = object({
    day  = string
    hour = number
  })
  default = {
    day  = "TUESDAY"
    hour = 0
  }
  validation {
    condition     = can(regex("^(MONDAY|TUESDAY|WEDNESDAY|THURSDAY|FRIDAY|SATURDAY|SUNDAY)$", var.maintenance_window.day)) && var.maintenance_window.hour >= 0 && var.maintenance_window.hour <= 23
    error_message = "Day of the week must be the capitalized day of the weeek (MONDAY-SUNDAY), and hour must be from 0 to 23."
  }
}

variable "availability_type" {
  description = "REGIONAL or ZONAL database."
  type        = string
  default     = "REGIONAL"
}

variable "memory_size_gb" {
  description = "Allocated memory capasitiy for the instance in GB."
  type        = number
  default     = 1
  validation {
    condition     = var.memory_size_gb >= 1
    error_message = "Memory size must be a whole number, and minimum 1."
  }
}

variable "redis_version" {
  description = "The redis version in the form REDIS_7_0."
  type        = string
  default     = "REDIS_7_0"
  validation {
    condition     = can(regex("^REDIS_[3-9]_[0-9X]$", var.redis_version))
    error_message = "Supports redis version 3.2 or higher, in the form REDIS_3_2."
  }
}

variable "redis_configs" {
  description = "The redis configuration flags."
  type        = map(string)
  default = {
    activedefrag     = "yes"
    maxmemory-policy = "allkeys-lfu"
  }
}

variable "enable_replicas" {
  description = "Enable read replicas"
  type        = bool
  default     = false
}

variable "replica_count" {
  description = "The number [1-5] of replica nodes. Defaults to 1."
  type        = number
  default     = 1
  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 5
    error_message = "Memory size must be a whole number, between 1 and 5 inclusive."
  }
}

variable "enable_auth" {
  description = "Enable authentication"
  type        = bool
  default     = false
}

variable "secret_key_prefix" {
  description = "Key prefix of secret. Ex. {secret_key_prefix: FIRST_} would give keys FIRST_REDIS_HOST, FIRST_REDIS_PASSWORD and so on"
  type        = string
  default     = ""
}

variable "create_kubernetes_resources" {
  description = "Optionally disables creating k8s resources -redis-connection and -redis-secret. Can be used to avoid overwriting existing resources on database creation."
  type        = bool
  default     = true
}

variable "add_redis_secret_manager_credentials" {
  description = "Set to false to not store redis credentials in secret manager"
  type        = bool
  default     = true
}

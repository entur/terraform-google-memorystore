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
    error_message = "Generation must be between [1,999]."
  }
}

# TODO: Dobbeltskjekke
variable "maintenance_window" {
  description = "The day of the week (MONDAY-SUNDAY), and hour of the day (0-24) in UTC to perform database instance maintenance. This is the start time of the one hour maintenance window."
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
    error_message = "Day of the week must be the capitalized day of the week (MONDAY-SUNDAY), and hour must be from 0 to 23."
  }
}

# TODO: Vi skal bare ha REGIONAL.
# variable "availability_type" {
#   description = "REGIONAL or ZONAL database."
#   type        = string
#   default     = "REGIONAL"
# }

# TODO: Hvordan konfigurerer vi denne?
# TODO: Fix validation to only allow valid node types
variable "node_type" {
  description = "The node type of the valkey instance. Options are STANDARD_SMALL, SHARED_CORE_NANO, HIGHMEM_MEDIUM, HIGHMEM_XLARGE "
  default     = "STANDARD_SMALL"
  validation {
    condition     = var.node_type == "STANDARD_SMALL" || var.node_type == "BASIC"
    error_message = "Node type must be either STANDARD_HA or BASIC."
  }
}

variable "engine_version" {
  description = "The engine version in the form VALKEY_<major>_<minor>."
  type        = string
  default     = "VALKEY_7_2"
  validation {
    condition     = can(regex("^VALKEY_[7-9]_[0-9X]$", var.engine_version))
    error_message = "Supports Valkey version 7.2, 8.0 or 9.0, in the form VALKEY_7_2."
  }
}

# TODO: Finne sane defaults på disse.
variable "engine_configs" {
  description = "The engine configuration flags."
  type        = map(string)
  default = {
    activedefrag     = "yes"
    maxmemory-policy = "allkeys-lfu"
  }
}

# TODO: Sjekke korleis clustring/replicas fungerer i valkey, og om det er noe vi må konfigurere her.
variable "replica_count" {
  description = "The number [0-5] of replica nodes. Defaults to 0."
  type        = number
  default     = 0
  validation {
    condition     = var.replica_count >= 0 && var.replica_count <= 5
    error_message = "Memory size must be a whole number, between 0 and 5 inclusive."
  }
}

variable "secret_key_prefix" {
  description = "Key prefix of secret. Ex. {secret_key_prefix: FIRST_} would give keys FIRST_REDIS_HOST, FIRST_REDIS_PASSWORD. Default is instance name"
  type        = string
  default     = ""
}

variable "add_memorystore_secret_manager_credentials" {
  description = "Set to false to not store memorystore credentials in secret manager"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The VPC network id, used for projects without a shared VPC."
  type        = string
  default     = null
}

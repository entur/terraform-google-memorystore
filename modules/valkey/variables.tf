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

locals {
  is_production = var.init.is_production
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled. Defaults to True in production, false otherwise."
  type        = bool
  default     = null
}

variable "name_override" {
  description = "Set to override the default memorystore name. Follows contentions; setting it to 'foo' in dev will result in the memorystore being named 'mem-foo-dev-001' (<prefix>-<var.name_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map and secret."
  type        = string
  default     = null
}

variable "region" {
  description = "The region of the memorystore instance."
  type        = string
  default     = "europe-west1"
}

variable "generation" {
  description = "Generation of the memorystore instance. Starts at 1, ends at 999. Will be padded with leading zeros."
  type        = number
  default     = 1

  validation {
    condition     = var.generation < 1000 && var.generation > 0
    error_message = "Generation must be between [1,999]."
  }
}

variable "maintenance_window" {
  description = "The day of the week (MONDAY-SUNDAY), and hour of the day (0-24) in UTC to perform database instance maintenance. This is the start time of the one hour maintenance window."
  type = object({
    day  = string
    hour = number
  })
  default = {
    day  = "TUESDAY"
    hour = 2
  }
  validation {
    condition     = can(regex("^(MONDAY|TUESDAY|WEDNESDAY|THURSDAY|FRIDAY|SATURDAY|SUNDAY)$", var.maintenance_window.day)) && var.maintenance_window.hour >= 0 && var.maintenance_window.hour <= 23
    error_message = "Day of the week must be the capitalized day of the week (MONDAY-SUNDAY), and hour must be from 0 to 23."
  }
}

variable "replica_count" {
  description = "The number [0-5] of replica nodes. Defaults to 0. 0 means no read replicas, just a primary."
  type        = number
  default     = 0
  validation {
    condition     = var.replica_count >= 0 && var.replica_count <= 5
    error_message = "Memory size must be a whole number, between 0 and 5 inclusive."
  }
}

variable "shard_count" {
  description = "Number of shards, more shards is scaling the instance horizontally out. "
  default = 1
  validation {
    condition = var.shard_count >= 0 && var.shard_count <=5
    error_message = "Shard count must be between 0 and 5"
  }
}

variable "mode" {
  description = "Cluster mode allows you to partition data between shards."
  default = "CLUSTER"
  validation {
    condition     = contains(["CLUSTER", "CLUSTER_DISABLED"], var.mode)
    error_message = "Mode must be either CLUSTER og CLUSTER_DISABLED"
  }  
}

variable "node_type" {
  description = "The node type of the valkey instance. Options are STANDARD_SMALL, SHARED_CORE_NANO, HIGHMEM_MEDIUM, HIGHMEM_XLARGE "
  default     = "STANDARD_SMALL"
  validation {
    condition     = contains(["STANDARD_SMALL", "SHARED_CORE_NANO", "HIGHMEM_MEDIUM", "HIGHMEM_XLARGE"], var.node_type)
    error_message = "Node type must be either STANDARD_SMALL, SHARED_CORE_NANO, HIGHMEM_MEDIUM or HIGHMEM_XLARGE."
  }
}

variable "engine_version" {
  description = "The engine version in the form VALKEY_<major>_<minor>."
  type        = string
  validation {
    condition     = can(regex("^VALKEY_.*", var.engine_version))
    error_message = "Supports Valkey version in the form VALKEY_7_2."
  }
}

variable "engine_configs" {
  description = "The engine configuration flags."
  type        = map(string)
  default = {
    maxmemory-policy = "allkeys-lfu"
  }
}

variable "secret_key_prefix" {
  description = "Key prefix of secret. Ex. {secret_key_prefix: FIRST_} would give keys FIRST_REDIS_HOST, FIRST_REDIS_PASSWORD. Default is instance name"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC network id, used for projects without a shared VPC."
  type        = string
  default     = null
}

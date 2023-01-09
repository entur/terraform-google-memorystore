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
  description = "The redis version in the form REDIS_4_0."
  type        = string
  default     = "REDIS_4_0"
  validation {
    condition     = can(regex("^REDIS_[3-9]_[0-9]$", var.redis_version))
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
  description = "The number [1-5] of replica nodes. Defaults to 2."
  type        = number
  default     = 2
  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 5
    error_message = "Memory size must be a whole number, between 1 and 5 inclusive."
  }
}

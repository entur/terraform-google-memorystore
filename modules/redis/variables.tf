variable "gcp_project" {
  description = "The GCP project id"
}

variable "zone" {
  description = "GCP default zone"
}

variable "region" {
  description = "GCP default region"
}

variable "labels" {
  description = "Labels used in all resources"
  type        = map(string)
  #default = {
  #  manager = "terraform"
  #  team    = "varelager"
  #  slack   = "talk-varelager"
  #  app     = "inventory"
  #

validation {
    condition     = length(var.labels.app) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.app))
    error_message = "The label 'app' is required and missing or empty or has not valid characters like uppercase or whitespace. Please specify the name of the application this resource belongs to (e.g. 'my-app')."
  }
   validation {
    condition     = length(var.labels.team) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.team))
    error_message = "The label 'team' is required and missing or empty. Please specify the name of the team who maintains this resource (e.g. 'team-foo')."
  }
  validation {
    condition     = length(var.labels.slack) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.slack))
    error_message = "The label 'slack' is required and missing or empty. Please specify a valid Slack channel where maintainers can be reached (e.g. '#talk-team')."
  }
  validation {
    condition     = length(var.labels.manager) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.manager))
    error_message = "The label 'manager' is required and missing or empty. Please add a valid label which describes how this resource is managed (e.g. 'terraform')."
  }

}

variable "reserved_ip_range" {
  description = "IP range for Redis, check Confluence `IP addressing scheme`"
}

variable "kubernetes_namespace" {
  description = "Your kubernetes namespace"

  validation {
    condition = (
      length(var.kubernetes_namespace) != 0 && can(regex("^[^A-Z\\s]*$", var.kubernetes_namespace))
    )
    error_message = "The length of kubernetes_namespace is not longer than 5 characters long or it has unvalid characters, like spaces or uppercase letters."
  }
}

variable "redis_instance_custom_name" {
  description = "Redis instance name override (empty string = use standard convention)"
  default     = ""

  #if we have a redis_instance_custom_name it must be longer than x characters, and cannot contain spaces or uppercase letters.
  validation {
    condition = (
      ((length(var.redis_instance_custom_name) == 0) ? true : ((length(var.redis_instance_custom_name) > 5)) && can(regex("^[^A-Z\\s]*$", var.redis_instance_custom_name)))
    )
    error_message = "The length of bucket_instance_custom_name is not longer than 5 characters long or it has unvalid characters, like spaces or uppercase letters ."
  }
}

variable "prevent_destroy" {
  description = "Prevents destruction of this redis instance"
  type        = bool
  default     = false
}

variable "enable_apis" {
  description = "Flag for enabling redis API in your project"
  type        = bool
  default     = false
}

variable "memory_size_gb" {
  description = "Redis memory size in GiB. Defaulted to 1 GiB"
  type        = number
}
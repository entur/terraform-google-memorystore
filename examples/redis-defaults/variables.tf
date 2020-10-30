variable "gcp_project" {
  description = "The GCP project id"
}

variable "zone" {
  description = "GCP default zone"
}

variable "region" {
  description = "GCP default region"
}

variable "kubernetes_namespace" {
  description = "Your kubernetes namespace"
  default     = "default"
}

variable "labels" {
  description = "Labels used in all resources"
  type        = map(string)
  default = {
    manager = "terraform"
    team    = "teamname"
    slack   = "talk-teamname"
    app     = "service"
  }
}

variable "redis_instance_custom_name" {
  description = "Redis instance name override (empty string = use standard convention)"
  default     = ""
}

variable "redis_reserved_ip_range" {
  description = "IP range for Redis, follow addressing scheme"
  default     = "10.110.20.8/29"
}

variable "prevent_destroy" {
  description = "Prevents destruction of this redis instance"
  type        = bool
  default     = false
}

variable "memory_size_gb" {
  description = "Redis memory size in GiB. Defaulted to 1 GiB"
  type        = number
}

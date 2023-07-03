locals {
  generation      = format("%03d", var.generation)
  connect_mode    = "PRIVATE_SERVICE_ACCESS"
  tier            = "STANDARD_HA"
  redis_shortname = var.name_override != null ? var.name_override : var.init.app.id
  redis_name      = "mem-${local.redis_shortname}-${var.init.environment}-${local.generation}"
  config_map_name = var.name_override != null ? "${var.init.app.name}-${var.name_override}-redis-connection" : "${var.init.app.name}-redis-connection"
}

resource "google_redis_instance" "main" {
  name           = local.redis_name
  project        = var.init.app.project_id
  tier           = local.tier
  memory_size_gb = var.memory_size_gb
  region         = var.region

  redis_version = var.redis_version
  redis_configs = var.redis_configs

  connect_mode       = local.connect_mode
  authorized_network = var.init.networks.vpc_id
  read_replicas_mode = var.enable_replicas ? "READ_REPLICAS_ENABLED" : "READ_REPLICAS_DISABLED"
  replica_count      = var.enable_replicas ? var.replica_count : null

  labels = var.init.labels

  maintenance_policy {
    weekly_maintenance_window {
      day = var.maintenance_window.day
      start_time {
        hours   = var.maintenance_window.hour
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }
  # https://github.com/hashicorp/terraform-provider-google/issues/11871
  # TODO: can be removed when the above issue is resolved
  lifecycle {
    ignore_changes = [
      maintenance_schedule,
    ]
  }
}

resource "kubernetes_config_map" "main_redis_connection" {
  metadata {
    name      = local.config_map_name
    namespace = var.init.app.name
    labels    = var.init.labels
  }
  data = {
    REDIS_HOST      = google_redis_instance.main.host
    REDIS_PORT      = google_redis_instance.main.port
    REDIS_READ_HOST = google_redis_instance.main.read_endpoint
    REDIS_READ_PORT = google_redis_instance.main.read_endpoint_port
  }
}

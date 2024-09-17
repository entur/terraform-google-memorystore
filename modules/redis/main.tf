locals {
  generation      = format("%03d", var.generation)
  connect_mode    = "PRIVATE_SERVICE_ACCESS"
  tier            = "STANDARD_HA"
  redis_shortname = var.name_override != null ? var.name_override : var.init.app.id
  redis_name      = "mem-${local.redis_shortname}-${var.init.environment}-${local.generation}"
  kubernetes_name = var.name_override != null ? "${var.init.app.name}-${var.name_override}" : var.init.app.name
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
  authorized_network = var.vpc_id != null ? var.vpc_id : var.init.networks.vpc_id
  auth_enabled       = var.enable_auth
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
}

locals {
  primary_connection = {
    REDIS_HOST = google_redis_instance.main.host
    REDIS_PORT = google_redis_instance.main.port
  }
  read_connection = {
    REDIS_READ_HOST = google_redis_instance.main.read_endpoint
    REDIS_READ_PORT = google_redis_instance.main.read_endpoint_port
  }
  secret = {
    REDIS_PASSWORD = google_redis_instance.main.auth_string
  }

}
locals {
  connection  = var.enable_replicas ? merge(local.primary_connection, local.read_connection) : local.primary_connection
  credentials = var.enable_auth ? merge(local.connection, local.secret) : local.connection
}

resource "kubernetes_config_map" "main_redis_connection" {
  count = var.create_kubernetes_resources ? 1 : 0
  metadata {
    name      = "${local.kubernetes_name}-redis-connection"
    namespace = var.init.app.name
    labels    = var.init.labels
  }
  data = local.connection
}

resource "kubernetes_secret" "main_redis_secret" {
  count = var.create_kubernetes_resources && var.enable_auth ? 1 : 0
  metadata {
    name      = "${local.kubernetes_name}-redis-secret"
    namespace = var.init.app.name
    labels    = var.init.labels
  }
  data = local.secret
}

resource "google_secret_manager_secret" "main_redis_secret_credentials" {
  for_each  = var.add_redis_secret_manager_credentials ? local.credentials : {}
  secret_id = "${var.secret_key_prefix}${each.key}"
  labels    = var.init.labels
  project   = var.init.app.project_id
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "main_redis_secret_credentials_version" {
  for_each    = var.add_redis_secret_manager_credentials ? local.credentials : {}
  secret      = google_secret_manager_secret.main_redis_secret_credentials[each.key].id
  secret_data = each.value
}

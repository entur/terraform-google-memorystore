locals {
  generation       = format("%03d", var.generation)
  valkey_shortname = var.name_override != null ? var.name_override : var.init.app.id
  valkey_name      = "mem-${local.valkey_shortname}-${var.init.environment}-${local.generation}"
}

locals {
  primary_connection = {
    VALKEY_HOST = google_memorystore_instance.main.host
    VALKEY_PORT = google_memorystore_instance.main.port
  }
  read_connection = {
    VALKEY_READ_HOST = google_memorystore_instance.main.read_endpoint
    VALKEY_READ_PORT = google_memorystore_instance.main.read_endpoint_port
  }
  secret = {
    VALKEY_PASSWORD = google_memorystore_instance.main.auth_string
  }
}

locals {
  connection  = var.replica_count ? merge(local.primary_connection, local.read_connection) : local.primary_connection
  credentials = merge(local.connection, local.secret)
}

resource "google_secret_manager_secret" "main_valkey_secret_credentials" {
  for_each  = var.add_valkey_secret_manager_credentials ? local.credentials : {}
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

resource "google_secret_manager_secret_version" "main_valkey_secret_credentials_version" {
  for_each    = var.add_valkey_secret_manager_credentials ? local.credentials : {}
  secret      = google_secret_manager_secret.main_valkey_secret_credentials[each.key].id
  secret_data = each.value
}

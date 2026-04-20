locals {
  generation       = format("%03d", var.generation)
  valkey_shortname = var.name_override != null ? var.name_override : var.init.app.id
  valkey_name      = "mem-${local.valkey_shortname}-${var.init.environment}-${local.generation}"
  deletion_protection_enabled = var.deletion_protection_enabled != null ? var.deletion_protection_enabled : (var.init.environment == "prd" ? true : false)
}

resource "google_memorystore_instance" "main" {
  instance_id = local.valkey_name
  project     = var.init.app.project_id
  mode = var.mode
  shard_count   = var.shard_count
  replica_count = var.replica_count
  zone_distribution_config {
    mode = "MULTI_ZONE"
  }  

  node_type      = var.node_type
  engine_version = var.engine_version
  engine_configs = var.engine_configs

  authorization_mode      = "IAM_AUTH"
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  server_ca_mode          = "GOOGLE_MANAGED_PER_INSTANCE_CA" # default value

  labels = var.init.labels
  desired_auto_created_endpoints {
    network    = var.init.networks.vpc_id
    project_id = var.init.app.project_id
  }
  location = var.region
  deletion_protection_enabled = local.deletion_protection_enabled
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
  credentials = {
    VALKEY_HOST = [
      for connection in flatten(google_memorystore_instance.main.endpoints[*].connections[*].psc_auto_connection[*]):
        connection.ip_address if connection.connection_type == "CONNECTION_TYPE_DISCOVERY"
    ][0]
    VALKEY_PORT = [
      for connection in flatten(google_memorystore_instance.main.endpoints[*].connections[*].psc_auto_connection[*]):
        connection.port if connection.connection_type == "CONNECTION_TYPE_DISCOVERY"
    ][0]
    # There are two certificates, but we only need one of them to connect, so we just take the first one.
    CA = google_memorystore_instance.main.managed_server_ca[0].ca_certs[0].certificates[0]
  }
}

resource "google_secret_manager_secret" "main_valkey_secret_credentials" {
  for_each  = local.credentials
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
  for_each    = local.credentials
  secret      = google_secret_manager_secret.main_valkey_secret_credentials[each.key].id
  secret_data = tostring(each.value)
}

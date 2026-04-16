locals {
  generation       = format("%03d", var.generation)
  valkey_shortname = var.name_override != null ? var.name_override : var.init.app.id
  valkey_name      = "mem-${local.valkey_shortname}-${var.init.environment}-${local.generation}"
}

resource "google_network_connectivity_service_connection_policy" "valkey_connection_policy" {
  name          = "valkey-service-connection-policy"
  project       = var.init.app.project_id
  location      = var.region
  service_class = "gcp-memorystore"
  description   = "Service connection policy for Valkey Memorystore instance"
  network       = google_compute_network.producer_net.id
  psc_config {
    subnetworks = [google_compute_subnetwork.producer_subnet.id]
  }
}

resource "google_compute_subnetwork" "producer_subnet" {
  name    = "producer-subnet"
  project = var.init.app.project_id
  # TODO: Mulig dette må håndteres i en local basert på env og generation, for å unngå kollisjoner mellom env og generasjoner.
  ip_cidr_range = var.compute_subnetwork_subnet_cidr
  region        = var.region
  network       = google_compute_network.producer_net.id
}

resource "google_compute_network" "producer_net" {
  name    = "producer-network"
  project = var.init.app.project_id

  auto_create_subnetworks = false
}

# END TODO: Flytte dette til core.

resource "google_memorystore_instance" "main" {
  instance_id = local.valkey_name
  project     = var.init.app.project_id

  shard_count   = var.shard_count
  replica_count = var.replica_count
  # TODO: zone_distribution_config - depends on ha setup
  # TODO: mode - depends on ha/replica setup

  node_type      = var.node_type
  engine_version = var.engine_version
  engine_configs = var.engine_configs

  authorization_mode      = "IAM_AUTH"
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  server_ca_mode          = "GOOGLE_MANAGED_PER_INSTANCE_CA" # default value

  labels = var.init.labels
  #desired_auto_created_endpoints {
  #  network    = var.init.networks.vpc_id
  #  project_id = var.init.app.project_id
  #}
  desired_auto_created_endpoints {
    network    = google_compute_network.producer_net.id
    project_id = var.init.app.project_id
  }
  location                    = var.region
  deletion_protection_enabled = false # TODO: Bruk flagg i variables for å enable/disable dette. Default true for prd, default false for non-prod.
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
  depends_on = [google_network_connectivity_service_connection_policy.valkey_connection_policy]
}

locals {
  credentials = {
    VALKEY_HOST = [
    for connection in google_memorystore_instance.main.endpoints[*].connections[*].psc_auto_connection[*]:
      {
        value = connection.connection_type == "CONNECTION_TYPE_DISCOVERY" ? connection.ip_address : ""
      }
    ]
    VALKEY_PORT = [
    for connection in google_memorystore_instance.main.endpoints[*].connections[*].psc_auto_connection[*]:
      {
        value = connection.port == 0 ? "" : connection.port
      }
    ]
    # There are two certificates, but we only need one of them to connect, so we just take the first one.
    CA = google_memorystore_instance.main.managed_server_ca[0].ca_certs[0].certificates[0].certificates
  }
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

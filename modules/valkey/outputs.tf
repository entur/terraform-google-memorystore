output "init" {
  description = "The init module used in the module."
  value       = var.init
}

output "instance" {
  description = "The memorystore instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memorystore_instance."
  value       = google_memorystore_instance.main
}

output "secret_manager_secret_ids" {
  value = values(google_secret_manager_secret.main_valkey_secret_credentials)[*].secret_id
}

output "instance_connection_info" {
  value = google_memorystore_instance.main.endpoints[*].connections[*].psc_auto_connection[*]
}

output "init" {
  description = "The init module used in the module."
  value       = var.init
}

output "memorystore_password" {
  description = "The auth password used to connect to the Valkey instance"
  sensitive   = true
  value       = google_memorystore_instance.main.auth_string
}

output "instance" {
  description = "The memorystore instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memorystore_instance."
  value       = google_memorystore_instance.main
}

output "secret_manager_secret_ids" {
  value = values(google_secret_manager_secret.main_valkey_secret_credentials)[*].secret_id
}

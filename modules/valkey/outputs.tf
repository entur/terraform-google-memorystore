output "init" {
  description = "The init module used in the module."
  value       = var.init
}

# TODO: Point to the correct value
output "memorystore_password" {
  description = "The auth password used to connect to the redis instance"
  sensitive   = true
  value       = google_redis_instance.main.auth_string
}

output "instance" {
  description = "The memorystore instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memorystore_instance."
  value       = google_redis_instance.main
}

output "secret_manager_secret_ids" {
  value = values(google_secret_manager_secret.main_memorystore_secret_credentials)[*].secret_id
}

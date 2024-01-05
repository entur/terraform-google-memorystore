output "init" {
  description = "The init module used in the module."
  value       = var.init
}

output "redis_password" {
  description = "The auth password used to connect to the redis instance"
  sensitive   = true
  value       = google_redis_instance.main.auth_string
}

output "instance" {
  description = "The redis instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance."
  value       = google_redis_instance.main
}

output "kubernetes_namespace" {
  description = "Name of the kubernetes namespace where the connection details configmap is deployed."
  value       = var.create_kubernetes_resources ? kubernetes_config_map.main_redis_connection[0].metadata[0].namespace : null
}

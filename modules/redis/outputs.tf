output "init" {
  value       = var.init
  description = "The init module used in the module."
}

output "instance" {
  value       = google_redis_instance.main
  description = "The redis instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance."
}

output "kubernetes_namespace" {
  description = "Name of the kubernetes namespace where the connection details configmap is deployed."
  value       = kubernetes_config_map.main_redis_connection.metadata[0].namespace
}

output "instance_name" {
  description = "The Valkey instance name."
  value       = module.valkey.instance.name
}

output "project_id" {
  description = "Project ID"
  value       = module.init.app.project_id
}

output "instance" {
  description = "The memorystore instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memorystore_instance."
  value       = module.valkey.instance
}

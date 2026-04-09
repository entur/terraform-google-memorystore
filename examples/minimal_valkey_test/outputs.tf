output "instance_name" {
  description = "The Valkey instance name."
  value       = module.valkey.instance.name
}

output "project_id" {
  description = "Project ID"
  value       = module.init.app.project_id
}

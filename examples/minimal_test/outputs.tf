output "instance_name" {
  description = "The redis instance name."
  value       = module.redis.instance.name
}

output "project_id" {
  description = "Project ID"
  value       = module.init.app.project_id
}

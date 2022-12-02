output "instance" {
  value       = module.redis.instance
  sensitive   = true
  description = "The redis instance output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance."
}

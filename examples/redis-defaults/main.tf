terraform {
  required_version = ">= 0.12"
}

module "redis" {
  #source = "github.com/entur/terraform//modules/redis"
  source               = "/mnt/c/Users/E180047/Documents/GitHub/terraform-gcp-redis/modules/redis"
  gcp_project          = var.gcp_project
  labels               = var.labels
  kubernetes_namespace = var.kubernetes_namespace
  region               = var.region
  zone                 = var.zone
  reserved_ip_range    = var.redis_reserved_ip_range
  prevent_destroy      = var.prevent_destroy
  memory_size_gb       = var.memory_size_gb
  redis_instance_custom_name = var.redis_instance_custom_name
}

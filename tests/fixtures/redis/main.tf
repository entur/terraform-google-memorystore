resource "random_integer" "random_revision_generation" {
  min = 1
  max = 999
}

module "init" {
  source      = "github.com/entur/terraform-google-init//modules/init?ref=v0.3.0"
  app_id      = "tfmodules"
  environment = "dev"
}

module "redis" {
  source     = "../../../modules/redis"
  init       = module.init
  generation = var.generation != null ? var.generation : random_integer.random_revision_generation.result
}

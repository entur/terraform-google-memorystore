resource "random_integer" "random_revision_generation" {
  # This resource block is used to randomize instance names for testing;
  # do not include this in a live configuration.
  min = 1
  max = 999
}

module "init" {
  # This is an example only; if you're adding this block to a live configuration,
  # make sure to use the latest release of the init module, found here:
  # https://github.com/entur/terraform-google-init/releases
  source      = "github.com/entur/terraform-google-init//modules/init?ref=v1.1.1"
  app_id      = "rocketlnch"
  environment = "sbx"
}

module "valkey" {
  # This is for local reference only; if you're using this module as a published
  # module from GitHub, the 'source' parameter must refer to it's public location.
  # See README.md for instructions.
  # source     = "github.com/entur/terraform-google-memorystore//modules/valkey?ref=vVERSION"
  source        = "../../modules/valkey"
  init          = module.init
  generation    = random_integer.random_revision_generation.result
  replica_count = 1
  shard_count   = 2
  engine_version = "VALKEY_8_0"
}

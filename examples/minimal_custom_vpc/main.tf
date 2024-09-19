# Example of how to create a redis instance with a custom vpc network and a vpc access connector
# This is useful when you want to connect to the redis instance from a firebase function or a cloud run functions ++
# and your project has a custom vpc network or you are not using our shared kubernetes clusters

# init module
module "init" {
  source      = "github.com/entur/terraform-google-init//modules/init?ref=v1.0.0"
  app_id      = "tfmodules"
  environment = "dev"
}

# Turn on networking api services
resource "google_project_service" "servicenetworking_api" {
  service            = "servicenetworking.googleapis.com"
  project            = module.init.app.project_id
  disable_on_destroy = false
}

# Turn on vpc access api services
resource "google_project_service" "vpcaccess_api" {
  service            = "vpcaccess.googleapis.com"
  project            = module.init.app.project_id
  disable_on_destroy = false
}

# VPC network for the redis instance
resource "google_compute_network" "redis_vpc_network" {
  name                    = "redis-vpc-network"
  project                 = module.init.app.project_id
  auto_create_subnetworks = false
}

# Redis module
module "redis" {
  #source                      = "github.com/entur/terraform-google-memorystore//modules/redis?ref=v1.0.2"
  source                      = "../../modules/redis"
  init                        = module.init
  create_kubernetes_resources = false
  vpc_id                      = google_compute_network.redis_vpc_network.id
  depends_on = [
    google_project_service.servicenetworking_api,
    google_compute_network.redis_vpc_network
  ]
}

# Create a internal address for the vpc access connector
resource "google_compute_global_address" "redis_internal_vpc_address" {
  name          = "redis-vpc-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.redis_vpc_network.id
  project       = module.init.app.project_id
}

# Create a vpc access connector to allow firebase functions to access the redis instance
resource "google_vpc_access_connector" "redis_access_vpc_connector" {
  name          = "redis-vpc-connector"
  project       = module.init.app.project_id
  ip_cidr_range = "10.8.0.0/28" #/28 is needed
  network       = google_compute_network.redis_vpc_network.id
  region        = "europe-west1"
  depends_on = [
    google_project_service.vpcaccess_api,
    google_compute_global_address.redis_internal_vpc_address
  ]
}

# if needed, you can grant the app engine service account access to the redis secrets
# Grant read rights to the redis secrets to the app engine service account
# resource "google_secret_manager_secret_iam_member" "redis-secrets-member" {
#   for_each   = toset(module.redis.secret_manager_secret_ids)
#   project    = module.init.app.project_id
#   secret_id  = each.key
#   role       = "roles/secretmanager.secretAccessor"
#   member     = "serviceAccount:${module.init.app.project_id}@appspot.gserviceaccount.com"
#   depends_on = [module.redis]
# }

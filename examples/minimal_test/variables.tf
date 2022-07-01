variable "init" {
  default = {
    app = {
      id         = "tfmodules"
      name       = "terraform-modules"
      owner      = "team-plattform"
      project_id = "ent-tfmodules-dev"
    }
    #app_name = "terraform-gcp-postgres" # After rename of the module, this name will be used.
    environment = "dev"
    labels = {
      app    = "terraform-modules"
      app_id = "tfmodules"
      env    = "dev"
      team   = "team-plattform"
      owner  = "team-plattform"
    }
    networks = {
      project_id = "ent-networks-dev-001"
      vpc_id     = "projects/ent-networks-dev-001/global/networks/vpc-dev-001"
    }
    is_production = false
  }
}

variable "generation" {
  default = 1
}

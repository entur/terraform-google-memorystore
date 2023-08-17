terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    google = {
      source  = "hashicorp/google"
      version = ">=4.76.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
  required_version = ">=0.13.2"
}

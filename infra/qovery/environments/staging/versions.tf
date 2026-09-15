terraform {
  required_version = ">= 1.6.0"

  required_providers {
    qovery = {
      source  = "qovery/qovery"
      version = "~> 0.82.0"
    }
  }
}

provider "qovery" {}

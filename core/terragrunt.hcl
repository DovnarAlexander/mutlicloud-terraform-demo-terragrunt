terraform {
  source = "git::git@github.com:DovnarAlexander/mutlicloud-terraform-demo-core.git?ref=v1.0.0"
}

locals {
  demo_vars = yamldecode(file(find_in_parent_folders("demo.yaml")))
}

remote_state {
  backend = "s3"

  config = {
    encrypt = true
    bucket  = format("%s-remote-state", local.demo_vars.name)
    key     = "core"
    region  = "eu-central-1"
  }
}

inputs = {
  environment = "general"
  location    = "europe"
}

include {
  path = find_in_parent_folders()
}

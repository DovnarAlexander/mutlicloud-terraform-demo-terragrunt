terraform {
  source = "git::git@github.com:DovnarAlexander/mutlicloud-terraform-demo-vpc.git?ref=v1.0.0"
}

locals {
  env_vars   = yamldecode(file(find_in_parent_folders("environment.yaml")))
  cloud_vars = yamldecode(file(find_in_parent_folders("cloud.yaml")))
}

remote_state {
  backend = "gcs"

  config = {
    bucket = dependency.core.outputs.state_bucket
    prefix = format("%s-%s-vpc", local.cloud_vars.cloud, local.env_vars.environment)
  }
}

inputs = {
  resource_group_name = dependency.core.outputs.azure_resource_group_name
}

dependency "core" {
  config_path = find_in_parent_folders("core")
}

include {
  path = find_in_parent_folders()
}
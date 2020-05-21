terraform {
  source = "git::git@github.com:DovnarAlexander/mutlicloud-terraform-demo-application.git?ref=v1.0.0"
}

locals {
  env_vars   = yamldecode(file(find_in_parent_folders("environment.yaml")))
  cloud_vars = yamldecode(file(find_in_parent_folders("cloud.yaml")))
}

remote_state {
  backend = "gcs"

  config = {
    bucket = dependency.core.outputs.state_bucket
    prefix = format("%s-%s-app", local.cloud_vars.cloud, local.env_vars.environment)
  }
}

inputs = {
  subnet_id           = dependency.vpc.outputs.subnet_id
  vpc_id              = dependency.vpc.outputs.vpc_id
  resource_group_name = dependency.core.outputs.azure_resource_group_name
}

dependency "core" {
  config_path = find_in_parent_folders("core")
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    subnet_id = "subnet-11100f"
    vpc_id    = "vpc-444111"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

include {
  path = find_in_parent_folders()
}

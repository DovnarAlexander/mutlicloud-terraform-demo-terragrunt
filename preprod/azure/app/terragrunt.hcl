terraform {
  source = "git::git@github.com:DovnarAlexander/mutlicloud-terraform-demo-application.git?ref=v1.0.2"
}

include {
  path = find_in_parent_folders("demo.hcl")
}

inputs = {
  resource_group_name = dependency.core.outputs.azure_resource_group_name
}

dependency "core" {
  config_path = "../../core"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    subnet_id = "subnet-11100f"
    vpc_id    = "vpc-444111"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

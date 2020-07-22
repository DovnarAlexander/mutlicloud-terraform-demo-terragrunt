terraform {
  source = "git@github.com:DovnarAlexander/mutlicloud-terraform-demo-application.git?ref=v1.0.0"
}

inputs = {
  resource_group_name = dependency.core.outputs.azure_resource_group_name
  subnet_id           = dependency.vpc.outputs.subnet_id
  vpc_id              = dependency.vpc.outputs.vpc_id
}

include {
  path = find_in_parent_folders("demo.hcl")
}
dependency "core" {
  config_path = "../../core"
  mock_outputs = {
    azure_resource_group_name = "terraform" // Should exist
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    subnet_id = "subnet-11100f"
    vpc_id    = "vpc-444111"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

terraform {
  source = "git@github.com:DovnarAlexander/mutlicloud-terraform-demo-vpc.git?ref=v1.0.0"
}

inputs = {
  resource_group_name = dependency.core.outputs.azure_resource_group_name
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

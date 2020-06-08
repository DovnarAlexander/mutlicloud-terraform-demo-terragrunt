terraform {
  source = "git::git@github.com:DovnarAlexander/mutlicloud-terraform-demo-vpc.git?ref=v1.0.1"
}

include {
  path = find_in_parent_folders("demo.hcl")
}

inputs = {
  resource_group_name = dependency.core.outputs.azure_resource_group_name
}

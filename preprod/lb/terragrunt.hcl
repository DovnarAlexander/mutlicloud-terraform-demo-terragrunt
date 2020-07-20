terraform {
  source = "git@github.com:DovnarAlexander/mutlicloud-terraform-demo-lb.git?ref=v1.0.0"
}

inputs = {
  subnet_id = dependency.vpc.outputs.subnet_id
  vpc_id    = dependency.vpc.outputs.vpc_id
  ips = list(
    dependency.aws.outputs.public_ip_address,
    dependency.azure.outputs.public_ip_address,
    dependency.gcp.outputs.public_ip_address
  )
}
include {
  path = find_in_parent_folders("demo.hcl")
}
dependency "vpc" {
  config_path = "../gcp/vpc"
  mock_outputs = {
    subnet_id = ""
    vpc_id    = ""
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}
dependency "aws" {
  config_path = "../aws/app"
  mock_outputs = {
    public_ip_address = "8.8.8.8"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}
dependency "azure" {
  config_path = "../azure/app"
  mock_outputs = {
    public_ip_address = "8.8.8.8"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}
dependency "gcp" {
  config_path = "../gcp/app"
  mock_outputs = {
    public_ip_address = "8.8.8.8"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "destroy"]
}

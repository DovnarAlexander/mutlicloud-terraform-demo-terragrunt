# This HCL file is used to centralize the place for remote state definition and all YAML variables
# inclusion
locals {
  global_stacks    = ["core", "lb"]
  stack            = basename(path_relative_to_include())
  cloud_path = basename(dirname(path_relative_to_include()))
  cloud            = contains(local.global_stacks, local.stack) ? "all" : local.cloud_path
  environment      = contains(local.global_stacks, local.stack) ? local.cloud_path : basename(dirname(dirname(path_relative_to_include())))
  environment_vars = yamldecode(file(format("%s/environment.yaml", local.environment)))
  demo_vars        = yamldecode(file("demo.yaml"))
}

remote_state {
  backend = "gcs"
  config = {
    bucket      = format("dom-terragrunt-multicloud-demo-%s-tf-state", local.environment)
    prefix      = format("%s-%s-%s", local.environment, local.cloud, local.stack)
    credentials = get_env("GOOGLE_CREDENTIALS", "")
    location    = local.demo_vars.cloud_location[local.environment_vars.location].gcp
    project     = local.demo_vars.gcp_project
  }
}

inputs = merge(
  local.demo_vars, local.environment_vars
  contains(local.global_stacks, local.stack) ? {} : yamldecode(file(format("%s/%s/cloud.yaml", local.environment, local.cloud)))
)

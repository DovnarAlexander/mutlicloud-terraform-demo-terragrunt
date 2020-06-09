# This HCL file is used to centralize the place for remote state definition and all YAML variables
# inclusion
locals {
  stack            = basename(path_relative_to_include())
  cloud            = local.stack != "core" ? basename(dirname(path_relative_to_include())) : "all"
  environment      = local.stack != "core" ? basename(dirname(dirname(path_relative_to_include()))) : basename(dirname(path_relative_to_include()))
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
  local.demo_vars,
  local.stack != "core" ? yamldecode(file(format("%s/%s/cloud.yaml", local.environment, local.cloud))) : {},
  local.environment_vars
)

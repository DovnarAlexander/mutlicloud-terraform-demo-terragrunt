# This HCL file is used to centralize the place for remote state definition and all YAML variables
# inclusion
locals {
  global_stacks    = ["core", "lb"]
  stack            = basename(path_relative_to_include())
  cloud_path       = basename(dirname(path_relative_to_include()))
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
  local.demo_vars, local.environment_vars,
  contains(local.global_stacks, local.stack) ? {} : yamldecode(file(format("%s/%s/cloud.yaml", local.environment, local.cloud)))
)

generate "provider" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      backend "gcs" {}
      required_providers {
        aws = ">= 2.60.0"
        azurerm = ">= 2.0"
        google = ">= 3.21"
      }
      required_version = "~> 0.12"
      experiments      = [variable_validation]
    }
    provider "aws" {
      region = local.cloud == "aws" ? var.cloud_location[var.location].aws : "us-east-1"
    }
    provider "azurerm" {
      features {}
    }
    provider "google" {
      region  = var.cloud_location[var.location].gcp
      project = var.gcp_project
    }
    provider "cloudflare" {
      email = var.email
    }
  EOF
}

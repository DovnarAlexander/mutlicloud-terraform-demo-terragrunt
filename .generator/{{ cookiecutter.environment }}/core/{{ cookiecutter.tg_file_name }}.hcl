terraform {
  source = "git::git@github.com:DovnarAlexander/mutlicloud-terraform-demo-core.git?ref=v1.0.2"
}

include {
  path = find_in_parent_folders("demo.hcl")
}

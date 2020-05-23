# Environment variables
inputs = merge(
  yamldecode(file("environment.yaml")),
  yamldecode(file(find_in_parent_folders("demo.yaml")))
)

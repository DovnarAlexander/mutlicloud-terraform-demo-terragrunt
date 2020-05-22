inputs = merge(
  yamldecode(file(find_in_parent_folders("environment.yaml"))),
  yamldecode(file(find_in_parent_folders("demo.yaml"))),
  yamldecode(file(find_in_parent_folders("cloud.yaml")))
)

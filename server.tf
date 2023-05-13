module "servers" {
  for_each = var.components
  source = "./module"
  env = var.env
  component_name = each.value["name"]
  component_password = lookup(each.value, "password", "null")
  instance_type = each.value["instance_type"]
}


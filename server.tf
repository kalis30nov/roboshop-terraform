module "servers" {
  for_each = var.components

  source = "./module"

  env = var.env
  instance_type = each.value["instance_type"]
  components_name = each.value["name"]
  components_password = lookup ( each.value, "password", "null")

}
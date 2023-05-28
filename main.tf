module "vpc" {
  source = "git::https://github.com/kalis30nov/roboshop-tf-vpc.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  tags = local.tags
  env = var.env
  subnets = each.value["subnets"]
}


module "app" {
  source = "git::https://github.com/kalis30nov/roboshop-tf-app.git"

  for_each = var.app
  instance_type = each.value["instance_type"]
  name =  each.value["name"]
  desired_capacity = each.value["desired_capacity"]
  max_size = each.value["max_size"]
  min_size = each.value["min_size"]

  env = var.env
  bastion_cidr = var.bastion_cidr

  subnet_ids    = element(lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet", null), each.value["subnet_name"], null), "subnet_ids", null),0)
  vpc_id = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  allow_app_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet", null), each.value["allow_app_cidr"], null), "subnet_cidrs", nul)
}






module "vpc" {
  source = "git::https://github.com/kalis30nov/roboshop-tf-vpc.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  tags = local.tags
  env = var.env
  subnets = each.value["subnets"]

  default_vpc_id =  var.default_vpc_id
  default_vpc_cidr =  var.default_vpc_cidr
  default_vpc_rtid = var.default_vpc_rtid
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
  tags = local.tags

  subnet_ids    = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id = local.vpc_id
  allow_app_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet", null), each.value["allow_app_cidr"], null), "subnet_cidrs", null)
}

module "doc_db" {
  source = "git::https://github.com/kalis30nov/terraform-tf-docdb.git"

  for_each = var.doc_db
  env = var.env
  tags = local.tags
  subnets    = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id = local.vpc_id
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  kms_arn = var.kms_arn
  engine_version = each.value["engine_version"]
}


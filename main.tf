module "vpc" {
  source = "git::https://github.com/kalis30nov/roboshop-tf-vpc.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  tags = local.tags
  env = var.env
  subnets = each.value["subnets"]
}

module "web" {
  source = "git::https://github.com/kalis30nov/roboshop-tf-app.git"

  for_each = var.app
  instance_type = each.value["instance_type"]
  subnet = element(lookup(lookup(module.vpc, each.value["subnet_type"], null), "subnet_ids", null), 0)

}
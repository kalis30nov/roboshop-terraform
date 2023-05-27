module "vpc" {
  source = "https://github.com/kalis30nov/roboshop-tf-vpc.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
}
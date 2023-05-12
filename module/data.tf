data "aws_ami" "centos" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}


data "aws_security_group" "allow-all" {
  name = "allow-all"
}

data "aws_route53_zone" "main" {
  name = "kalis30nov.online"
}
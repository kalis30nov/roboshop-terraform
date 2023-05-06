
resource "aws_spot_instance_request" "instance" { 
  for_each               = var.components
  availability_zone      = "us-east-1a"
  wait_for_fulfillment   = true
  ami                    = data.aws_ami.centos.image_id
  instance_type          = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]
  tags = {
    Name = each.value["name"]
         }
  }

resource "null_resource" "provisioner" {
  depends_on = [aws_spot_instance_request.instance, aws_route53_record.dnsroute, aws_ec2_tag.tag]
  for_each   = var.components
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_spot_instance_request.instance[each.value["name"]].private_ip
    }

    inline = [
      "rm -rf roboshop-shell",
      "git clone https://github.com/kalis30nov/roboshop-shell.git",
      "cd roboshop-shell",
      "sudo bash ${each.value["name"]}.sh ${lookup(each.value, "password", "dummy")}"
      ]
  }
}


resource "aws_ec2_tag" "tag" {
  for_each               = var.components
  resource_id            = aws_spot_instance_request.instance[each.value["name"]].spot_instance_id
  key                    = "Name"
  value                  = each.value["name"]
}

resource "aws_route53_record" "dnsroute" {
  for_each = var.components
  zone_id = data.aws_route53_zone.main.zone_id
  name     = "${each.value["name"]}-dev.kalis30nov.online"
  type     = "A"
  ttl      = "300"
  records  = [aws_spot_instance_request.instance[each.value["name"]].private_ip]
}




 


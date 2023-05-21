
resource "aws_spot_instance_request" "instance" { 
  availability_zone      = "us-east-1a"
  wait_for_fulfillment   = true
  ami                    = data.aws_ami.centos.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  tags = {
    Name = local.name
         }
  }

resource "null_resource" "provisioner" {
  depends_on = [aws_spot_instance_request.instance, aws_route53_record.dnsroute, aws_ec2_tag.tag]
  triggers = {
    private_ip = aws_spot_instance_request.instance.private_ip
  }

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_spot_instance_request.instance.private_ip
    }

    inline = var.app_type == "db" ? local.db_commands : local.app_commands
  }
}


resource "aws_ec2_tag" "tag" {
  resource_id            = aws_spot_instance_request.instance.spot_instance_id
  key                    = "Name"
  value                  = var.component_name
}

resource "aws_route53_record" "dnsroute" {
  zone_id = data.aws_route53_zone.main.zone_id
  name     = "${var.component_name}-dev.kalis30nov.online"
  type     = "A"
  ttl      = "300"
  records  = [aws_spot_instance_request.instance.private_ip]
}

resource "aws_iam_role" "role" {
  name = "${var.component_name}-${var.env}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


  tags = {
    tag-key = "${var.component_name}-${var.env}-role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.component_name}-${var.env}-role"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "ssm-ps-policy" {
  name = "${var.component_name}-${var.env}-ssm-ps-policy"
  role = aws_iam_role.role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "ssm:GetParameterHistory",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource" : [
          "arn:aws:kms:us-east-1:714769180788:key/a977a2e7-5100-41ff-aa73-9d83f1a4ebee",
          "arn:aws:ssm:us-east-1:714769180788:parameter/${var.env}.${var.component_name}.*"
        ]
      }
    ]
  })
}
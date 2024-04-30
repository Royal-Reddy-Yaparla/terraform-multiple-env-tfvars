resource "aws_instance" "web" {
  for_each = var.instance_names
  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.key == "mongodb" || each.key == "shipping" || each.key == "mysql" ? "t2.medium" : "t2.micro"
  vpc_security_group_ids = [aws_security_group.practicetf.id]

  tags = {
    Name = "${each.key}-${var.environment}"
    Project= var.project_name
    Environment= var.environment
    Terraform = "true"
  }
}


resource "aws_route53_record" "www" {
  for_each = aws_instance.web
  zone_id = var.zone_id
  name    = "${each.key}-${var.environment}.${var.hostname}"
  type    = "A"
  ttl     = 1
  records = [startswith(each.key,"web") ? each.value.public_ip : each.value.private_ip ]
}

resource "aws_security_group" "practicetf" {
  name        = "practice_sg"
  # description = "Allow TLS inbound traffic and all outbound traffic"
  # vpc_id      = aws_vpc.main.id

  tags = {
    Name = "practice_sg-${var.environment}"
  }

  ingress {
    description = "Allow all ports"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description = "Allow all ports"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
}


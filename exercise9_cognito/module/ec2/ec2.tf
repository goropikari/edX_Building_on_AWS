resource "aws_instance" "webserver" {
  ami                    = "ami-08d489468314a58df" # Amazon Linux
  instance_type          = "t2.micro"
  availability_zone      = var.az
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data

  tags = {
    Name = var.tag_name
  }
}

output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}

output "webserver_instance_id" {
  value = aws_instance.webserver.id
}

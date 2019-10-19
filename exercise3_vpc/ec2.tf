resource "aws_instance" "Ex3WebServer" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = aws_subnet.public_1.id
  key_name               = aws_key_pair.default.id
  user_data              = file("./UserDataScript.sh")

  tags = {
    Name = "Ex3WebServer"
  }
}

output "public_ip" {
  value = aws_instance.Ex3WebServer.public_ip
}

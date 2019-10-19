module "webserver_1" {
  source               = "./module/ec2"
  tag_name             = "WebServer1"
  az                   = data.aws_availability_zones.available.names[0]
  subnet_id            = aws_subnet.public_1.id
  key_name             = aws_key_pair.default.id
  iam_instance_profile = aws_iam_instance_profile.webserver.name
  security_group_ids   = [module.web_servers_sg.security_group_id]
  user_data            = file("./user_data.sh")
}

module "webserver_2" {
  source               = "./module/ec2"
  tag_name             = "WebServer2"
  az                   = data.aws_availability_zones.available.names[1]
  subnet_id            = aws_subnet.public_2.id
  key_name             = aws_key_pair.default.id
  iam_instance_profile = aws_iam_instance_profile.webserver.name
  security_group_ids   = [module.web_servers_sg.security_group_id]
  user_data            = file("./user_data.sh")
}

output "server1_public_ip" {
  value = module.webserver_1.webserver_public_ip
}

output "server2_public_ip" {
  value = module.webserver_2.webserver_public_ip
}

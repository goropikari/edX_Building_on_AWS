resource "aws_db_instance" "default" {
  identifier             = "edx-photos-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "Photos"
  username               = "master"
  password               = "foobarbaz"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  lifecycle {
    ignore_changes = [password]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "example"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "rds_hostname" {
  value = aws_db_instance.default.endpoint
}


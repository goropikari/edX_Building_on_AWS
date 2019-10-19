# Obtain the security_groups_ids associated with the Cloud9 EC2 instance.
data "aws_security_groups" "cloud9" {
  filter {
    name   = "group-name"
    values = ["*${aws_cloud9_environment_ec2.example.id}*"]
  }
}

output "cloud9_security_group" {
  value = data.aws_security_groups.cloud9.ids[0]
}

data "aws_security_group" "cloud9_sg" {
  id = data.aws_security_groups.cloud9.ids[0]
}

output "cloud9_security_group_name" {
  value = data.aws_security_group.cloud9_sg.name
}

# RDS
resource "aws_security_group" "mysql_sg" {
  name   = "mysql_sg"
  vpc_id = aws_vpc.edx_build_aws_vpc.id
}

resource "aws_security_group_rule" "cloud9_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_groups.cloud9.ids[0]
  security_group_id        = aws_security_group.mysql_sg.id
}

resource "aws_security_group_rule" "webserver_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.web_servers_sg.security_group_id
  security_group_id        = aws_security_group.mysql_sg.id
}

resource "aws_security_group_rule" "lambda_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda_sg.id
  security_group_id        = aws_security_group.mysql_sg.id
}

# web server
module "web_servers_sg" {
  source      = "./module/sg"
  name        = "web-server-sg"
  vpc_id      = aws_vpc.edx_build_aws_vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_servers_sg.security_group_id
}

resource "aws_security_group" "lambda_sg" {
  name   = "labels-lambda-sg"
  vpc_id = aws_vpc.edx_build_aws_vpc.id
}

resource "aws_security_group_rule" "lambda_sg_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_sg.id
}

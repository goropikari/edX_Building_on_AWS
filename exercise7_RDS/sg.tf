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

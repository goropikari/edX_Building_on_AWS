module "sg" {
  source      = "./sg"
  name        = "ssh-sg"
  vpc_id      = aws_vpc.edx_build_aws_vpc.id
  port        = 22
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.sg.security_group_id
}

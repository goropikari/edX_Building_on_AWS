resource "aws_lb" "photos" {
  name                       = "photos-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false # for terraform destroy

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  security_groups = [
    module.web_servers_sg.security_group_id
  ]
}

output "alb_dns_name" {
  value = aws_lb.photos.dns_name
}

output "load_balancer_dns" {
  value = aws_lb.photos.dns_name
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.photos.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.photos.id
  }

}

resource "aws_lb_target_group" "photos" {
  name                 = "webserver-target"
  target_type          = "instance"
  vpc_id               = aws_vpc.edx_build_aws_vpc.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.photos]
}

resource "aws_lb_target_group_attachment" "server_1" {
  target_group_arn = aws_lb_target_group.photos.arn
  target_id        = module.webserver_1.webserver_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "server_2" {
  target_group_arn = aws_lb_target_group.photos.arn
  target_id        = module.webserver_2.webserver_instance_id
  port             = 80
}

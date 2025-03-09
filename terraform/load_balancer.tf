

resource "aws_lb_target_group" "lb_target" {
  name     = "aqui-express-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  tags = {
    project = "aqui-express"
  }
  tags_all = {
    project = "aqui-express"
  }
}

resource "aws_autoscaling_attachment" "attach_lb_target" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn = aws_lb_target_group.lb_target.arn
}

resource "aws_lb" "elb" {
  name = "aqui-express-elb"
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  internal = false
  subnets = data.aws_subnets.default.ids
  

  security_groups = [ aws_security_group.rds_sg.id ]

  tags = {
    project = "aqui-express"
  }

  tags_all = {
    project = "aqui-express"
  }
}

output "load_balancer_host" {
  value = aws_lb.elb.dns_name
}

resource "aws_lb_listener" "elb_listener" {
  depends_on = [ aws_lb_target_group.lb_target ]

  load_balancer_arn = aws_lb.elb.arn
  port = 80

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target.arn
  }
}
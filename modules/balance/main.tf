#module/balance/main

resource "aws_lb" "load_balancer" {
  name               = "loadbalancer"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.web_sg]
  idle_timeout       = 400
  subnets            = tolist(var.public_subnet)

  depends_on = [
    var.web_asg
  ]
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "wk23-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port     #80
  protocol = var.tg_protocol #"HTTP"
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  health_check {
    healthy_threshold   = var.lb_healthy   #2
    unhealthy_threshold = var.lb_unhealthy #2
    timeout             = var.lb_timeout   #3
    interval            = var.lb_interval  #30
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener_port     #80
  protocol          = var.listener_protocol #"HTTP"
  default_action {
    type   = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
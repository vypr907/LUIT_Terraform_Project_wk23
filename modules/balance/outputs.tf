#module/balance/outputs

output "alb_tg" {
  value = aws_lb_target_group.alb_tg.arn
}

output "elb" {
  value = aws_lb.load_balancer.id
}

output "alb_dns" {
  value = aws_lb.load_balancer.dns_name
}
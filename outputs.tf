#root/outputs

output "alb_dns" {
    value = module.balance.load_balancer.alb_dns
}
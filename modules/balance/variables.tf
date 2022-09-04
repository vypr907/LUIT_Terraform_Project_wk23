#module/balance/variables

variable "public_subnet" {}
variable "vpc_id" {}
variable "web_sg" {}
variable "web_asg" {}
variable "subnet_id" {}

variable "tg_port" {
  default = 80
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "lb_healthy" {}
variable "lb_unhealthy" {}
variable "lb_timeout" {}
variable "lb_interval" {}

variable "listener_port" {
  default = 80
}
variable "listener_protocol" {
  default = "HTTP"
}

variable "security_groups" {}
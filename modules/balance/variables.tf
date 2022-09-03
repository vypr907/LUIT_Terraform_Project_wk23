#module/balance/variables

variable "public_subnet" {}
variable "vpc_id" {}
variable "web_sg" {}
variable "web_asg" {}
variable "subnet_id" {}

variable "tg_port" {}
variable "tg_protocol" {}

variable "lb_healthy" {}
variable "lb_unhealthy" {}
variable "lb_timeout" {}
variable "lb_interval" {}

variable "listener_port" {}
variable "listener_protocol" {}

variable "security_groups" {}
#modules/compute/variables

variable "pub_sg_cpu" {}
variable "priv_sg_cpu" {}

variable "pub_sub_cpu" {}
variable "priv_sub_cpu" {}

variable "key_name" {}
variable "elb" {}
variable "alb_target" {}

variable "bast_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "web_instance_type" {
  type    = string
  default = "t2.micro"
}
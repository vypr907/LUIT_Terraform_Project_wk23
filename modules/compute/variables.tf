#modules/compute/variables

variable "public_sg" {}
variable "private_sg" {}

variable "public_subnet" {}
variable "private_subnet" {}

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
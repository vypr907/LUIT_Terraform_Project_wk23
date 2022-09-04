#root/variables

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "access_ip" {
  type = string
}

variable "pub_sub_ct" {
  type    = number
  default = 3
}

variable "priv_sub_ct" {
  type    = number
  default = 3
}

variable "max_subs" {
  type    = number
  default = 20
}

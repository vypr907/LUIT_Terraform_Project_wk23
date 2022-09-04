#modules/network/variables

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "access_ip" {
  type = string
}

variable "pub_sub_ct" {
  type = number
}

variable "priv_sub_ct" {
  type = number
}

variable "max_subnets" {
  type = number
}
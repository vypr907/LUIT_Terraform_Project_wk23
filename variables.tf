#root/variables

variable "vpc_cidr_root" {
    type = string
    default = "10.0.0.0/16"
}

variable "access_ip" {
    type = string
}

variable "pub_sub_ct" {3}
variable "priv_sub_ct" {3}
variable "max_subs" {20}

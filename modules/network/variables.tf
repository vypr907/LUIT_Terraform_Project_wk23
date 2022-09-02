#modules/network/variables

variable "vpc_cidr_ntwk" {
    type = string
}

variable "public_cidrs_ntwk" {
    type = list(any)
}

variable "private_cidrs_ntwk" {
    type = list(any)
}

variable "access_ip" {}
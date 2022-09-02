#root/main

# establish network
module "network" {
    source = "./modules/network"
    access_ip = var.access_ip
    
    #cidr things
    vpc_cidr = var.vpc_cidr_root
    public_cidrs = [for i in range(2,255,2): cidrsubnet(var.vpc_cidr,8,i)]
    private_cidrs = [for i in range(2,255,2): cidrsubnet(var.vpc_cidr,8,i)]
    
    #subnets
    public_subnet_count = var.pub_sub_ct
    private_subnet_count = var.priv_sub_ct
    max_subnets = var.max_subs
    
    #routing
    #gateways
    #eip
    #security groups
}

# populate network
module "compute" {
    source = "./modules/compute"
    public_sg = module.network.public_sg
    p
}

# scale network
#root/main

# establish network
module "network" {
  source    = "./modules/network"
  access_ip = var.access_ip

  #cidr things
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]

  #subnets
  public_subnet_count  = 3
  private_subnet_count = 3
  max_subnets          = 20

  #routing
  #gateways
  #eip
  #security groups
}

# populate network
module "compute" {
  source         = "./modules/compute"
  public_sg      = module.network.public_sg
  private_sg     = module.network.private_sg
  public_subnet  = module.network.public_subnet
  private_subnet = module.network.private_subnet
  elb            = module.balance.elb
  alb_tg         = module.balance.alb_tg
  key_name       = "sacred_icon"
}

# scale network
module "balance" {
  source        = "./modules/balance"
  public_subnet = module.network.public_subnet
  vpc_id        = module.network.vpc_id
  web_sg        = module.network.web_sg
  web_asg       = module.network.web_asg
}
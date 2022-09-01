#root/main

# establish network

# populate network
module "compute" {
    source = "./modules/compute"
}

# scale network
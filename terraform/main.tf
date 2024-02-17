module "rg" {
  source = "./modules/resource_group"
  name   = "rg-web"
  location = "East US" // Example location, customize as needed
}


module "network" {
  source             = "./modules/network"
  resource_group_name = module.rg.name
}

module "vm_linux_app" {
  source                  = "./modules/vm/linux_vm"
  resource_group_name     = module.rg_app.name
}
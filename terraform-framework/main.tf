provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "./modules/resource_group"
}

module "virtual_network" {
  source              = "./modules/virtual_network"
  resource_group_name = module.resource_group.name
}

module "subnet" {
  source              = "./modules/subnet"
  virtual_network_id  = module.virtual_network.id
}

module "vm_web" {
  source                = "./modules/vm"
  subnet_id             = module.subnet.web_subnet_id
  vm_os                 = "Windows"
  vm_additional_config  = {
    "IIS" = true
  }
}

module "vm_app" {
  source                = "./modules/vm"
  subnet_id             = module.subnet.app_subnet_id
  vm_os                 = "Linux"
  vm_additional_config  = {
    "IIS" = true
  }
}

module "vm_oracle_db" {
  source                = "./modules/vm"
  subnet_id             = module.subnet.oracle_db_subnet_id
  vm_os                 = "Linux"
  vm_additional_config  = {
    "Oracle" = "19"
  }
}

module "vm_mssql_db" {
  source                = "./modules/vm"
  subnet_id             = module.subnet.mssql_db_subnet_id
  vm_os                 = "Windows"
  vm_additional_config  = {
    "MSSQL" = "AlwaysOn"
  }
}

module "storage_account" {
  source              = "./modules/storage_account"
  resource_group_name = module.resource_group.name
}

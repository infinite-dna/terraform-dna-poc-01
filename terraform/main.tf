 
provider "azurerm" {
  features {}
}

module "rg_web" {
  source = "./modules/resource_group"
  name   = "rg-web"
  location = "East US" // Example location, customize as needed
}

module "rg_app" {
  source = "./modules/resource_group"
  name   = "rg-app"
  location = "East US" // Example location, customize as needed
}

module "rg_oracle" {
  source = "./modules/resource_group"
  name   = "rg-oracle"
  location = "East US" // Example location, customize as needed
}

module "rg_mssql" {
  source = "./modules/resource_group"
  name   = "rg-mssql"
  location = "East US" // Example location, customize as needed
}

module "vnet" {
  source          = "./modules/vnet"
  resource_group_name = module.rg_web.name
  vnet_name         = "my-vnet"
  address_space     = ["10.0.0.0/16"]
}

module "subnet_web" {
  source             = "./modules/subnet"
  resource_group_name = module.rg_web.name
  vnet_name          = module.vnet.name
  subnet_name        = "web-subnet"
  subnet_address_prefix = "10.0.1.0/24"
}

module "subnet_app" {
  source             = "./modules/subnet"
  resource_group_name = module.rg_app.name
  vnet_name          = module.vnet.name
  subnet_name        = "app-subnet"
  subnet_address_prefix = "10.0.2.0/24"
}

module "subnet_oracle" {
  source             = "./modules/subnet"
  resource_group_name = module.rg_oracle.name
  vnet_name          = module.vnet.name
  subnet_name        = "oracle-subnet"
  subnet_address_prefix = "10.0.3.0/24"
}

module "subnet_mssql" {
  source             = "./modules/subnet"
  resource_group_name = module.rg_mssql.name
  vnet_name          = module.vnet.name
  subnet_name        = "mssql-subnet"
  subnet_address_prefix = "10.0.4.0/24"
}

module "vm_windows" {
  source                  = "./modules/vm/windows_vm"
  resource_group_name     = module.rg_web.name
  subnet_id               = module.subnet_web.subnet_id
  vm_name                 = "windows-vm"
  vm_size                 = "Standard_DS2_v2"
  admin_username          = "adminuser"
  admin_password          = "P@ssw0rd123!" // Example password, replace with secure value
}

module "vm_linux_app" {
  source                  = "./modules/vm/linux_vm"
  resource_group_name     = module.rg_app.name
  subnet_id               = module.subnet_app.subnet_id
  vm_name                 = "linux-app-vm"
  vm_size                 = "Standard_DS2_v2"
  admin_username          = "adminuser"
  admin_ssh_key           = file("~/.ssh/id_rsa.pub") // Example path to SSH public key, customize as needed
}

module "vm_linux_oracle" {
  source                  = "./modules/vm/linux_vm"
  resource_group_name     = module.rg_oracle.name
  subnet_id               = module.subnet_oracle.subnet_id
  vm_name                 = "linux-oracle-vm"
  vm_size                 = "Standard_DS2_v2"
  admin_username          = "adminuser"
  admin_ssh_key           = file("~/.ssh/id_rsa.pub") // Example path to SSH public key, customize as needed
}

module "vm_mssql" {
  source                  = "./modules/vm/windows_vm"
  resource_group_name     = module.rg_mssql.name
  subnet_id               = module.subnet_mssql.subnet_id
  vm_name                 = "mssql-vm"
  vm_size                 = "Standard_DS2_v2"
  admin_username          = "adminuser"
  admin_password          = "P@ssw0rd123!" // Example password, replace with secure value
}

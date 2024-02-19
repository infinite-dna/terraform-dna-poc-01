# main.tf

module "example_rg" {
  source = "./modules/rg_module"

  resource_group_name = "custom_rg"
  location            = "West US"
}

output "example_rg_id" {
  value = module.example_rg.resource_group_id
}

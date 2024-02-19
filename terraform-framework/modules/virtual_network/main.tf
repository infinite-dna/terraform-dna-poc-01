variable "resource_group_name" {}
variable "environment" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-vnet"
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

output "id" {
  value = azurerm_virtual_network.vnet.id
}

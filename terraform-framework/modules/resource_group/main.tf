variable "environment" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-rg"
  location = var.location
}

output "name" {
  value = azurerm_resource_group.rg.name
}

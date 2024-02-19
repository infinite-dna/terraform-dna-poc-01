variable "virtual_network_id" {}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_id
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_id
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "oracle_db" {
  name                 = "oracle-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_id
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "mssql_db" {
  name                 = "mssql-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_id
  address_prefixes     = ["10.0.4.0/24"]
}

output "web_subnet_id" {
  value = azurerm_subnet.web.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "oracle_db_subnet_id" {
  value = azurerm_subnet.oracle_db.id
}

output "mssql_db_subnet_id" {
  value = azurerm_subnet.mssql_db.id
}

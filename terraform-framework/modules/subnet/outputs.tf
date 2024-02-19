output "web_subnet_id" {
  description = "The ID of the web subnet"
  value       = azurerm_subnet.web.id
}

output "app_subnet_id" {
  description = "The ID of the app subnet"
  value       = azurerm_subnet.app.id
}

output "oracle_db_subnet_id" {
  description = "The ID of the Oracle DB subnet"
  value       = azurerm_subnet.oracle_db.id
}

output "mssql_db_subnet_id" {
  description = "The ID of the MSSQL DB subnet"
  value       = azurerm_subnet.mssql_db.id
}

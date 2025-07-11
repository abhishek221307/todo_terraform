resource "azurerm_mssql_server" "polaris-dbserver" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = "1.2"


}

output "server_id"  {
  value = azurerm_mssql_server.polaris-dbserver.id
}


 
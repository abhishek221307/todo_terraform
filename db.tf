resource "azurerm_mssql_server" "polaris-dbserver" {
  name                         = "pol-mssqlserver"
  resource_group_name          = azurerm_resource_group.polarisrg.name
  location                     = azurerm_resource_group.polarisrg.location
  version                      = "12.0"
  administrator_login          = "poldbmanager"
  administrator_login_password = "Letme!n123"
  minimum_tls_version          = "1.2"


  tags = {
    environment = "pol-production"
  }
}
resource "azurerm_mssql_database" "polaris-db" {
  name         = "polaris-db"
  server_id    = azurerm_mssql_server.polaris-dbserver.id
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  tags = {
    environment = "production"
    owner       = "abhishek"
    project     = "todo-app"
  }
}
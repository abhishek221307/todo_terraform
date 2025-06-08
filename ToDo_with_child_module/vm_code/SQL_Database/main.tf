resource "azurerm_mssql_database" "polaris-db" {
  name         = var.sql_database_name
  server_id    = var.server_id
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

}


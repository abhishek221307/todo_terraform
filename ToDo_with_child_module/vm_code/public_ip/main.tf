resource "azurerm_public_ip" "polaris-pip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
output "public_ip" {
  value = azurerm_public_ip.polaris-pip.id
}
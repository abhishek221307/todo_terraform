resource "azurerm_resource_group" "polarisrg" {
  name     = "polaris-rg"
  location = "Japan East"
}

resource "azurerm_virtual_network" "polaris-vnet" {
  name                = "polaris-network"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.polarisrg.location
  resource_group_name = azurerm_resource_group.polarisrg.name
}
resource "azurerm_public_ip" "polaris-pip" {
  name                = "polaris-public-ip"
  location            = azurerm_resource_group.polarisrg.location
  resource_group_name = azurerm_resource_group.polarisrg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_public_ip" "polaris-pip1" {
  name                = "polaris-public-ip1"
  location            = azurerm_resource_group.polarisrg.location
  resource_group_name = azurerm_resource_group.polarisrg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_subnet" "polaris-frontend" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.polarisrg.name
  virtual_network_name = azurerm_virtual_network.polaris-vnet.name
  address_prefixes     = [cidrsubnet("192.168.0.0/16", 8, 7)]
}
resource "azurerm_subnet" "polaris-backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.polarisrg.name
  virtual_network_name = azurerm_virtual_network.polaris-vnet.name
  address_prefixes     = [cidrsubnet("192.168.0.0/16", 8, 8)]
}

resource "azurerm_network_interface" "polaris" {
  name                = "polaris-nic"
  location            = azurerm_resource_group.polarisrg.location
  resource_group_name = azurerm_resource_group.polarisrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.polaris-frontend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.polaris-pip.id
  }
}

resource "azurerm_network_interface" "polaris1" {
  name                = "polaris1-nic"
  location            = azurerm_resource_group.polarisrg.location
  resource_group_name = azurerm_resource_group.polarisrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.polaris-backend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.polaris-pip1.id
  }
}

resource "azurerm_linux_virtual_machine" "polaris-vm2" {
  name                            = "polaris-backend"
  resource_group_name             = azurerm_resource_group.polarisrg.name
  location                        = azurerm_resource_group.polarisrg.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Letme!n123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.polaris1.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}


resource "azurerm_linux_virtual_machine" "polaris-vm1" {
  name                            = "polaris-frontend"
  resource_group_name             = azurerm_resource_group.polarisrg.name
  location                        = azurerm_resource_group.polarisrg.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Letme!n123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.polaris.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
output "front_end_public_ip" {
  description = "this is public ip of frontend VM"
  value       = azurerm_public_ip.polaris-pip.ip_address
}
output "backend_end_public_ip" {
  description = "this is public ip of backend VM"
  value       = azurerm_public_ip.polaris-pip1.ip_address
}
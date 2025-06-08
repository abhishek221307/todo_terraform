module "resource_group_name" {
  source = "../../resource_group"

  rg_name  = "ajay_rg"
  location = "Japan East"
}

module "vnet" {
    depends_on = [ module.resource_group_name ]
  source = "../../Vnet"

  vnet_name     = "ajay_vnet"
  address_space = ["10.0.0.0/16"]
  location      = "Japan East"
  rg_name       = "ajay_rg"
}

module "subnet_frontend" {
    depends_on = [ module.vnet ]
  source = "../../subnet"

  subnet_name      = "ajay_subnet_frontend"
  rg_name          = "ajay_rg"
  vnet_name        = "ajay_vnet"
  address_prefixes = ["10.0.1.0/24"]
}


module "subnet_backend" {
    depends_on = [ module.vnet ]
  source = "../../subnet"

  subnet_name      = "ajay_subnet_backend"
  rg_name          = "ajay_rg"
  vnet_name        = "ajay_vnet"
  address_prefixes = ["10.0.2.0/24"]
}


module "public_ip" {
  source = "../../public_ip"

  pip_name = "ajay_pip"
  location = "Japan East"
  rg_name  = "ajay_rg"
}

module "public_ip_backend" {
  source = "../../public_ip"

  pip_name = "ajay_pip_backend"
  location = "Japan East"
  rg_name  = "ajay_rg"
}

module "virtual_machine_frontend" {
    depends_on = [ module.subnet_frontend ]

  source = "../../VM"


  nic_name             = "ajay_nic_new"
  location             = "Japan East"
  subnet_id            = module.subnet_frontend.subnet_id
  public_ip_address_id = module.public_ip.public_ip
  vm_name              = "ajay_vm"
  rg_name              = "ajay_rg"
  admin_username       = "ajay"
  admin_password       = "Ajay@123"

}

module "virtual_machine_backend" {
    depends_on = [ module.subnet_backend ]
  source = "../../VM"


  nic_name             = "ajay_nic_new"
  location             = "Japan East"
  subnet_id            = module.subnet_backend.subnet_id
  public_ip_address_id = module.public_ip_backend.public_ip
  vm_name              = "ajay_vm"
  rg_name              = "ajay_rg"
  admin_username       = "ajay"
  admin_password       = "Ajay@123"

}

module "server" {
    depends_on = [ module.resource_group_name ]
  source = "../../SQL_Server"

  sql_server_name = "ajay-server"
  rg_name         = "ajay_rg"
  location        = "Japan East"

  administrator_login          = "poldbmanager"
  administrator_login_password = "Letme!n123"
}

module "datebade" {
    depends_on = [ module.server ]
    source = "../../SQL_Database"
   sql_database_name        = "ajay-database"
  server_id    = module.server.server_id
}
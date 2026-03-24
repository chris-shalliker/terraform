provider "azurerm" {
  features {}
}

locals {
  # Build up the naming standard of the resources - lookup the location code from the location name - default to uks"
  resource_name = "${var.prefix}-${lookup(var.location_prefix, var.location, "uks")}-${var.resource_name}"
  # Generate the name of the different resource types using the generated resource name
  resource_group_name         = "${local.resource_name}-rg"
  virtual_network_name        = "${local.resource_name}-vnet"
  network_security_group_name = "${local.resource_name}-nsg"
}

# Create the Resource Group used to store all Resources
resource "azurerm_resource_group" "ccrg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

# Module to deploy the basic networking required for an IaaS VM - VNet, Subnet and NSG with a single rule
module "networking" {
  source                      = "./networking"
  location                    = var.location
  virtual_network_name        = local.virtual_network_name
  vnet_address_space          = var.vnet_address_space
  resource_group_name         = azurerm_resource_group.ccrg.name
  tags                        = var.tags
  network_security_group_name = local.network_security_group_name
}

# Module to deploy the tfe VM
module "tfe_vm" {
  source              = "./tfe-vm"
  resource_group_name = azurerm_resource_group.ccrg.name
  location            = var.location
  frontend_subnet_id  = module.networking.frontend_subnet_id
  backend_subnet_id   = module.networking.backend_subnet_id
  tags                = var.tags
  virtual_machine = {
    size        = var.virtual_machine.size
    sku         = var.virtual_machine.sku
    user_name   = var.resource_name
    public_key  = file("tfe_rsa.pub")
    private_key = file("tfe_rsa")
  }
  /* password = random_password.password.result */
  network_security_group_id = module.networking.nsg_id
}

/* resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
} */